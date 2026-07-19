# Erzeugt die Offline-Ausgabe: zwei doppelklickbare Dateien mit eingebettetem
# Katalog - laufen ohne Server und ohne Internet.
#
#   sonntagsfinder-offline.html           = Ausflugs-Bibliothek (Hauptseite)
#   sonntagsfinder-vorlagen-offline.html  = Aktivitaetsvorlagen ohne festes Ziel
#
# Beide Dateien funktionieren einzeln; die Verlinkung untereinander greift nur,
# wenn sie im selben Ordner liegen. Nach jeder Aenderung an catalog.json oder
# events.json neu ausfuehren:
#
#   powershell -ExecutionPolicy Bypass -File .\make-offline.ps1
#
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$cat  = Get-Content (Join-Path $root "catalog.json") -Raw -Encoding UTF8
$ev   = Get-Content (Join-Path $root "events.json") -Raw -Encoding UTF8

if ($cat -match "</script>" -or $ev -match "</script>") { throw "JSON enthaelt '</script>' - Einbettung unsicher." }

$stamp = Get-Date -Format "yyyy-MM-dd"
$inject = "<script>window.EMBEDDED_CATALOG = $cat; window.EMBEDDED_EVENTS = $ev; window.EMBEDDED_BUILD = `"$stamp`";</script>"

$mainOut = "sonntagsfinder-offline.html"
$tmplOut = "sonntagsfinder-vorlagen-offline.html"

function Build-Page($sourceName, $targetName) {
  $html = Get-Content (Join-Path $root $sourceName) -Raw -Encoding UTF8
  if ($html.IndexOf("<body>") -lt 0) { throw "Marker <body> nicht gefunden - $sourceName geaendert?" }
  $html = $html.Replace("<body>", "<body>`n$inject")
  # Querverweise auf die jeweils andere Offline-Datei umbiegen
  $html = $html.Replace('href="vorlagen.html"', "href=`"$tmplOut`"")
  $html = $html.Replace('href="./"', "href=`"$mainOut`"")
  $out = Join-Path $root $targetName
  [System.IO.File]::WriteAllText($out, $html, (New-Object System.Text.UTF8Encoding $false))
  Write-Output "Erzeugt: $out"
}

Build-Page "index.html" $mainOut
Build-Page "vorlagen.html" $tmplOut
Write-Output "Datenstand eingebettet am $stamp"
