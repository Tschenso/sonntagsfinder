# Sonntagsfinder Würzburg

Offene, redaktionell gepflegte Bibliothek kostengünstiger Sonntags- und Gruppenausflüge
im Umkreis von Würzburg – als rein statische Website ohne Konten, ohne Tracking und
ohne Backend.

**Live-Prinzip:** `index.html` lädt `catalog.json` und rechnet die Ampel
(*Passt / Vorher prüfen / Passt nicht*) clientseitig gegen die Einstellungen der
Besucherin: Budget pro Person, Budget pro Gruppe, Gruppengröße, maximale Wegstrecke.
Es wird nichts gespeichert und nichts übertragen.

---

## Struktur

| Datei | Zweck |
|---|---|
| `index.html` | komplette Website (Layout, Filter, Ampellogik) – ohne Build-Step |
| `catalog.json` | **die Datenquelle**: alle Einträge, Quellen und Prüfdaten |
| `events.json` | kuratierte, zeitlich begrenzte Hinweise (laufen automatisch ab) |
| `sonntagsfinder-offline.html` | **Offline-Ausgabe**: eine doppelklickbare Datei mit eingebetteten Daten |
| `make-offline.ps1` | erzeugt die Offline-Ausgabe neu aus `index.html` + JSON-Dateien |
| `README.md` | dieses Dokument |

Eine inhaltliche Änderung ist immer eine Änderung an `catalog.json` oder `events.json`.
`index.html` muss dafür nicht angefasst werden.

### Funktionen der Website

- **Suche**: mehrere Suchwörter (UND-Verknüpfung), umlaut-tolerant („kappele“ findet „Käppele“),
  durchsucht Titel, Ort, Typ, Beschreibung und Vorbereitungshinweise.
- **Filter**: Entfernung (Slider bis 120 km), Ausflugsstufe (Stadt ≤ 5 km / Umkreis ≤ 15 km /
  Tagesausflug ≤ 50 km / **Fernziel > 50 km** / Vorlagen), Kategorien-Chips (Mehrfachauswahl),
  verfügbare Zeit, Umgebung, „nur sonntags bestätigt / stufenfrei / kostenlos“.
- **Kategorien**: Jeder Eintrag trägt ein redaktionell gepflegtes `tags`-Feld. Erlaubte Werte:
  `regenfest`, `tiere`, `wasser`, `wald-natur`, `garten-park`, `museum-kultur`,
  `wissenschaft`, `bewegung`, `aussicht`, `ohne-auto`. Bedeutung von `ohne-auto`:
  zu Fuß oder mit Bahn/Bus ab Würzburg gut erreichbar – nur vergeben, wenn das
  plausibel belegt ist (Stadtgebiet oder Bahnhalt am Ort). Neue Kategorien zuerst
  hier dokumentieren, dann in `index.html` (Konstante `TAGS`) ergänzen.
- **Ampel**: rechnet clientseitig gegen Budget pro Person, Budget pro Gruppe und Gruppengröße.
- **Anpassung**: alle Einstellungen werden automatisch **lokal im Browser** gespeichert
  (localStorage, ohne Konto) und beim nächsten Besuch wiederhergestellt. Ein geteilter
  Link (URL-Hash) hat Vorrang vor gespeicherten Einstellungen.
- **Ticket-Links**: Einträge mit `booking_url` zeigen einen „Tickets & Buchung“-Button
  (z. B. experimenta Heilbronn, PLAYMOBIL-FunPark, Wildpark Bad Mergentheim).

### Events pflegen (`events.json`)

Zeitlich begrenzte Hinweise (Feste, Sonderöffnungen, Sonderausstellungen) kommen in
`events.json`. Jeder Eintrag **muss** ein `valid_until` (ISO-Datum) haben – danach
blendet die Website ihn automatisch aus; es kann also nie ein abgelaufenes Event
öffentlich stehen bleiben. Beispiel:

```json
{
  "title": "Fränkisches Weinfest",
  "locality": "Volkach",
  "date_text": "14.–18. August 2026",
  "valid_until": "2026-08-18",
  "url": "https://www.volkach.de/",
  "note": "Sonntags gut besucht; Anreise früh planen."
}
```

Die „Aktuelles“-Box verlinkt zusätzlich dauerhaft auf die offiziellen
Veranstaltungskalender (Stadt, Landkreis, Frankentourismus) – die brauchen keine Pflege.

## Offline-Version (ohne Server, ohne Internet)

`sonntagsfinder-offline.html` ist die komplette Website als **eine Datei mit
eingebetteten Daten** – einfach doppelklicken, sie öffnet sich im Browser und
funktioniert vollständig offline (Filter, Ampel, Suche, gespeicherte Einstellungen).

- **Weitergeben:** Datei per USB-Stick, internem Laufwerk oder Mailanhang verteilen –
  keine Installation, keine Rechte, kein IT-Aufwand.
- **Grenzen:** Die Quell- und Ticket-Links im Detailbereich brauchen Internet;
  die Daten sind auf dem Stand des Erzeugungsdatums eingefroren (steht im Fußbereich).
- **Aktualisieren:** Nach jeder Änderung an `catalog.json`/`events.json` neu erzeugen:

```powershell
cd Sonntagsfinder-Public
powershell -ExecutionPolicy Bypass -File .\make-offline.ps1
```

## Lokal testen (Server-Variante)

`index.html` lädt die Daten per `fetch()` – das funktioniert nicht über `file://`.
Zum lokalen Testen der Server-Variante einen Mini-Server starten:

```powershell
cd Sonntagsfinder-Public
python -m http.server 8080
# dann http://localhost:8080 öffnen
```

## Auf GitHub Pages veröffentlichen

1. Auf github.com ein neues **öffentliches** Repository anlegen (z. B. `sonntagsfinder`).
2. Lokal verknüpfen und hochladen:
   ```powershell
   git remote add origin https://github.com/<DEIN-NAME>/sonntagsfinder.git
   git push -u origin main
   ```
3. Im Repo: **Settings → Pages → Source: „Deploy from a branch“ → Branch `main`, Ordner `/ (root)` → Save.**
4. Nach ca. 1–2 Minuten ist die Seite unter
   `https://<DEIN-NAME>.github.io/sonntagsfinder/` erreichbar.
5. **Einmalig:** In `index.html` oben im `CONFIG`-Block `repoIssues` auf
   `https://github.com/<DEIN-NAME>/sonntagsfinder/issues` setzen und committen.
   Ab dann führt „Info melden“ auf GitHub-Issues statt auf die E-Mail-Adresse.
   (Die E-Mail-Adresse kann dort ebenfalls angepasst oder durch eine dedizierte
   Adresse ersetzt werden – für eine öffentliche Seite empfehlenswert.)

## Redaktions-Workflow (PR-Prinzip)

Das Vier-Augen-Prinzip läuft über Git, nicht über Anwendungscode:

1. **Jede inhaltliche Änderung** (neuer Eintrag, Preisänderung, neues Prüfdatum)
   erfolgt als Branch + **Pull-Request** gegen `main` – auch von den Maintainern selbst.
   Kleine Korrekturen können direkt über die GitHub-Weboberfläche eingereicht werden
   („Edit this file“ erstellt automatisch einen PR).
2. **Keine Selbstfreigabe:** In den Repo-Einstellungen unter
   *Settings → Branches → Branch protection rule* für `main` aktivieren:
   „Require a pull request before merging“ + „Require approvals (1)“.
   Damit prüft immer eine zweite Person, technisch erzwungen.
3. **Quellenpflicht:** Jeder Eintrag braucht mindestens eine Quelle mit `url`,
   `publisher`, `status` und `checked_on`. Statuswerte:
   - `official` – offizielle öffentliche Primärquelle (nur damit ist „Passt“ erreichbar)
   - `derived` – redaktionell abgeleitet → Ampel zeigt höchstens „Vorher prüfen“
   - `conflict` – Quellen widersprechen sich → immer „Vorher prüfen“, im PR begründen
   - `stale` – Prüfintervall abgelaufen → immer „Vorher prüfen“
   - `internal` – ortsunabhängige Methodenvorlage ohne externe Quelle
4. **Prüfdaten:** Bei jeder Prüfung `source_checked_on` aktualisieren und ein neues
   `next_review_on` setzen (Faustregel: Öffnung/Preis 90 Tage, saisonal 30 Tage,
   stabile Wege 180 Tage, interne Vorlagen 365 Tage). Ist `next_review_on`
   überschritten, zeigt die Seite automatisch „⚠ Prüfung überfällig“ – veraltete
   Einträge werden also sichtbar, nicht versteckt.
5. **Neuer Eintrag:** Einen bestehenden Block in `catalog.json` kopieren, alle Felder
   ausfüllen (`distance_from_wuerzburg_km` = einfache Straßenkilometer ab Würzburg Hbf,
   ca.-Werte zulässig, `null` für ortsunabhängige Vorlagen; Beträge in Cent). Optional
   `booking_url` für einen direkten Ticket-/Buchungslink. Fernziele über 50 km sind
   ausdrücklich erlaubt und erscheinen als eigene Stufe „Fernziel“.
6. **Grundsätze:** Keine Personendaten, keine Wohn- oder Gruppenadressen, keine
   Eignungsaussagen über einzelne Personen. Unsicherheit wird nie als „Passt“
   dargestellt – im Zweifel `derived`/`unknown` lassen und die Ampel entscheiden lassen.

## Herkunft & Attribution

- Datenbasis: redaktioneller Basiskatalog v1 (`2026-07-15.1`) des Sonntagsfinder-Piloten;
  30 Einträge, 38 Quellenbelege, Stand Juli 2026.
- Entfernungsangaben wurden mit OpenStreetMap-Daten erarbeitet:
  © [OpenStreetMap-Mitwirkende, ODbL](https://www.openstreetmap.org/copyright).
- Die Seite erhebt keine personenbezogenen Daten; der Filterzustand liegt nur in der
  URL-Adresszeile (teilbar, aber ohne Personenbezug).

## Grenzen

Der Sonntagsfinder ist eine Vorabhilfe, keine Zusage: Öffnungszeiten, Preise und
Zugänglichkeit können sich kurzfristig ändern. Maßgeblich ist immer die verlinkte
Originalquelle. Die Seite entscheidet nicht über die pädagogische, gesundheitliche
oder aufsichtliche Eignung für einzelne Personen oder Gruppen.
