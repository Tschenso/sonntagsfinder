# Redaktionswerkzeug: prueft alle Quell-, Booking- und Event-URLs des Katalogs
# auf Erreichbarkeit und listet faellige redaktionelle Reviews.
#
#   powershell -ExecutionPolicy Bypass -File .\check-links.ps1
#
# Hinweis: Einzelne Seiten blocken automatisierte Abrufe (HTTP 403) oder
# antworten langsam - solche Treffer bitte manuell im Browser gegenpruefen,
# bevor eine Quelle als tot gilt.

$ErrorActionPreference = "Continue"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$today = Get-Date -Format "yyyy-MM-dd"
$ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Sonntagsfinder-Linkcheck/1.0"

$cat = Get-Content (Join-Path $root "catalog.json") -Raw -Encoding UTF8 | ConvertFrom-Json
$ev  = Get-Content (Join-Path $root "events.json")  -Raw -Encoding UTF8 | ConvertFrom-Json

# --- URLs einsammeln (dedupliziert, mit Herkunft) ---
$urls = @{}
function Add-Url([string]$u, [string]$from) {
  if ([string]::IsNullOrWhiteSpace($u)) { return }
  if (-not $urls.ContainsKey($u)) { $urls[$u] = New-Object System.Collections.ArrayList }
  [void]$urls[$u].Add($from)
}
foreach ($a in $cat.activities) {
  foreach ($s in $a.sources) { Add-Url $s.url $a.seed_key }
  Add-Url $a.booking_url ($a.seed_key + " (booking)")
}
foreach ($e in $ev.events) { Add-Url $e.url ("event: " + $e.title) }

Write-Output ("Pruefe " + $urls.Count + " eindeutige URLs (Katalog " + $cat.catalog_version + ") ...")
Write-Output ""

# --- Erreichbarkeit pruefen: erst HEAD, bei Ablehnung GET ---
function Test-Url([string]$u) {
  foreach ($method in @("Head", "Get")) {
    try {
      $r = Invoke-WebRequest -Uri $u -Method $method -UseBasicParsing -TimeoutSec 20 -UserAgent $ua
      return @{ ok = $true; code = [int]$r.StatusCode; note = $method }
    } catch {
      $resp = $_.Exception.Response
      if ($null -ne $resp -and $null -ne $resp.StatusCode) {
        $code = [int]$resp.StatusCode
        if ($method -eq "Head" -and ($code -eq 403 -or $code -eq 405 -or $code -eq 501)) { continue }
        return @{ ok = $false; code = $code; note = $method }
      }
      if ($method -eq "Get") { return @{ ok = $false; code = 0; note = $_.Exception.Message.Split("`n")[0] } }
    }
  }
  return @{ ok = $false; code = 0; note = "unbekannt" }
}

$dead = New-Object System.Collections.ArrayList
$okCount = 0
foreach ($u in ($urls.Keys | Sort-Object)) {
  $res = Test-Url $u
  if ($res.ok) { $okCount++ }
  else {
    $status = if ($res.code -gt 0) { "HTTP " + $res.code } else { "FEHLER: " + $res.note }
    [void]$dead.Add([pscustomobject]@{ Status = $status; Eintrag = ($urls[$u] -join ", "); URL = $u })
  }
  Start-Sleep -Milliseconds 400
}

Write-Output ("Ergebnis: " + $okCount + " von " + $urls.Count + " URLs erreichbar.")
if ($dead.Count -gt 0) {
  Write-Output ""
  Write-Output "=== Nicht erreichbare / auffaellige URLs (manuell gegenpruefen) ==="
  $dead | Format-Table -AutoSize -Wrap | Out-String -Width 220 | Write-Output
} else {
  Write-Output "Keine toten Links gefunden."
}

# --- Faellige redaktionelle Reviews ---
$due = $cat.activities | Where-Object { $_.next_review_on -and $_.next_review_on -le $today } |
  Sort-Object next_review_on |
  Select-Object @{n="Faellig seit";e={$_.next_review_on}}, @{n="Eintrag";e={$_.seed_key}}, @{n="Titel";e={$_.title}}
Write-Output ""
if ($due) {
  Write-Output "=== Faellige Reviews (next_review_on erreicht) ==="
  $due | Format-Table -AutoSize | Out-String -Width 220 | Write-Output
} else {
  Write-Output "Keine faelligen Reviews."
}
$soon = $cat.activities | Where-Object { $_.next_review_on -and $_.next_review_on -gt $today -and $_.next_review_on -le (Get-Date).AddDays(30).ToString("yyyy-MM-dd") } |
  Sort-Object next_review_on |
  Select-Object @{n="Faellig am";e={$_.next_review_on}}, @{n="Eintrag";e={$_.seed_key}}
if ($soon) {
  Write-Output "=== In den naechsten 30 Tagen faellig ==="
  $soon | Format-Table -AutoSize | Out-String -Width 220 | Write-Output
}
