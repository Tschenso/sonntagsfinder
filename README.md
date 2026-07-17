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
| `catalog.json` | **die einzige Datenquelle**: alle Einträge, Quellen und Prüfdaten |
| `README.md` | dieses Dokument |

Eine inhaltliche Änderung ist immer eine Änderung an `catalog.json`.
`index.html` muss dafür nicht angefasst werden.

## Lokal testen

`fetch()` funktioniert nicht über `file://`. Zum lokalen Testen einen Mini-Server starten:

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
   `null` für ortsunabhängige Vorlagen; Beträge in Cent). Optional `booking_url` für
   einen direkten Ticket-/Buchungslink.
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
