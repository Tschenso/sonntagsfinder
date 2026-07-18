# Erzeugt sonntagsfinder-offline.html: die komplette Website als eine einzige
# doppelklickbare Datei mit eingebettetem Katalog - laeuft ohne Server und ohne
# Internet. Nach jeder Aenderung an catalog.json oder events.json neu ausfuehren:
#
#   powershell -ExecutionPolicy Bypass -File .\make-offline.ps1
#
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$html = Get-Content (Join-Path $root "index.html") -Raw -Encoding UTF8
$cat  = Get-Content (Join-Path $root "catalog.json") -Raw -Encoding UTF8
$ev   = Get-Content (Join-Path $root "events.json") -Raw -Encoding UTF8

if ($cat -match "</script>" -or $ev -match "</script>") { throw "JSON enthaelt '</script>' - Einbettung unsicher." }
if ($html.IndexOf("<body>") -lt 0) { throw "Marker <body> nicht gefunden - index.html geaendert?" }

$stamp = Get-Date -Format "yyyy-MM-dd"
$inject = "<script>window.EMBEDDED_CATALOG = $cat; window.EMBEDDED_EVENTS = $ev; window.EMBEDDED_BUILD = `"$stamp`";</script>"
$html = $html.Replace("<body>", "<body>`n$inject")

$out = Join-Path $root "sonntagsfinder-offline.html"
[System.IO.File]::WriteAllText($out, $html, (New-Object System.Text.UTF8Encoding $false))
Write-Output "Erzeugt: $out (Datenstand eingebettet am $stamp)"
