# Pflegelog – Sonntagsfinder Würzburg

Nachvollziehbare Pflegehistorie der Seite. **Jeder Monats-Pflegelauf** (nach der
Pflege-Checkliste in der [README](README.md#pflege-checkliste-monatlich-ca-3060-minuten))
bekommt hier einen Eintrag: Datum, Katalogversion, `check-links`-Ergebnis und die
abgearbeiteten Reviews bzw. Befunde.

---

## Pflegeläufe (neueste zuerst)

### 2026-08-10 · Mobil-Nachbesserung: Ergebnisse kommen zuerst
Nachmessung nach dem Bedienelement-Lauf vom Vortag brachte zwei echte Ärgernisse ans Licht:

- **Man sah auf dem Handy kein einziges Ziel, ohne zu scrollen.** Filterpanel,
  Ampel-Erklärung und Neuigkeiten schoben die erste Karte unter die Falz.
- **Das Sortierfeld hatte 13,6 px Schriftgröße.** Unter 16 px zoomt iOS beim
  Antippen in die Seite hinein und kommt nicht von selbst zurück.

**Behoben:**
- Filterpanel startet unter 880 px eingeklappt, hinter einem 48 px hohen Knopf mit
  Zähler für gesetzte Filter – ein zugeklappter, unbemerkt aktiver Filter wäre die
  schlechtere Falle als der lange Scrollweg.
- Neuigkeiten und Ampel-Erklärung rutschen unter 880 px per `order` unter die
  Ergebnisse.
- Alle Eingabe- und Auswahlfelder auf 16 px.
- Der Touch-Medienblock stand zu früh im Stylesheet und wurde von den allgemeinen
  Chip- und Feldregeln überschrieben; er steht jetzt am Ende.

**Nachgemessen** bei 375 × 812 px: erste Karte bei **574 px**, eine Karte ohne
Scrollen sichtbar, Schriftgrößen 16 px, kein Überlauf, keine Konsolenfehler.
Umschalter geprüft: Voreinstellung → Zähler 1, 27 Treffer; Zurücksetzen → Zähler
aus, 97 Treffer.

Gleiche Maßnahme wie auf der Schwesterseite, hier eigenständig gepflegt und
gemessen – die Seiten bleiben getrennte Produkte.

---

### 2026-08-09 · Mobil-Audit: Bedienelemente fingerfreundlich
- **Layout war bereits mobiltauglich:** `viewport`-Meta korrekt, bei 375 px kein
  horizontaler Überlauf, Raster fällt auf eine Spalte, das Filterpanel wird unter
  880 px `static` (kein Eigen-Scroll, kein Klebe-Effekt), Überschrift skaliert per `clamp`.
- **Befund:** die Bedienelemente waren zu klein für den Daumen. Der Entfernungs-
  Schieberegler maß nur 16 px Höhe, Kategorie-Chips 31 px, Voreinstellungen 33 px,
  Kästchen und Auswahlfeld unter 40 px. Empfohlenes Mindestmaß für Touch: 44 px.
- **Behoben** über einen Medienblock `(pointer: coarse), (max-width: 880px)`:
  Schieberegler 44 px (Griff 26 px), Chips und Voreinstellungen 40 px, Kästchenzeilen
  44 px, Sortierauswahl 44 px, Zurücksetzen 46 px, Themenknopf 44 px.
- **Nachgemessen:** 375 px und 768 px, jeweils kein Überlauf, kein Bedienelement mehr
  unter 40 px, keine Konsolenfehler. Auf dem Tablet zwei Karten pro Reihe.
- Reine Darstellungsänderung, Katalog unberührt.

### 2026-08-09 · Verweis-Audit über alle 97 Ziele
- **Struktur (nahezu fehlerfrei):** 97 Ziele, alle mit mindestens einer Quelle; keine leeren
  URLs, keine doppelten `seed_key` oder Titel. Zwei Links liefen noch über `http` statt `https`.
- **`check-links`:** 160 von 165 URLs erreichbar. Behoben:
  - **Wildpark an den Eichen** – `schweinfurt.de/leben-freizeit/wildpark/index.html` liefert 404
    (Seite umgezogen) → auf `schweinfurt.de/kultur-freizeit/tourismusfreizeit/wildpark` umgestellt.
  - **experimenta Heilbronn** – der Ticket-Deeplink `/relaunch/TicketAssistant` ist inzwischen
    ebenfalls 404 → `booking_url` auf den Shop-Einstieg `shop.experimenta.science` gesetzt.
    (Das ist der zweite Wechsel dieses Links; die experimenta baut ihren Shop offenbar um.)
  - **Planetenweg** – Betreiberseite ist auch über **https** erreichbar → URL angehoben.
  - Nicht geändert: **Kreuzberg Rhön** bleibt auf `http`, weil das TLS-Zertifikat der Seite auf
    einen anderen Hostnamen ausgestellt ist – https würde eine Warnung erzeugen.
  - Zwei weitere Meldungen sind unkritisch: **Schwarzes Moor** (HTTP 403, Bot-Block) und
    **Scherenburg Gemünden** (Verbindungsabbruch, transient) – beide Seiten laden im Browser.
- **Ohne amtliche Quelle:** zwei Einträge (**Mainwiesen/Skatepark**, **Bio-Rundweg Gadheim**).
  Beide haben Stadt- bzw. Landkreis-Seiten als Beleg, sind aber bewusst als `derived` geführt,
  weil die Seiten den Inhalt nur dünn stützen. Bleibt so dokumentiert.
- **Ergebnis:** 158 Quellenbelege, davon 154 amtlich; keine fälligen Reviews.

---

## Hinweise zur Pflege

- Der Link-Check meldet regelmäßig **HTTP 403** von einzelnen Portalen – das ist ein Bot-Block,
  kein toter Link. Jede Meldung vor dem Ändern einmal im Browser gegenprüfen.
- `catalog.json` immer als **UTF-8 ohne BOM** speichern, sonst lädt der Browser das JSON nicht.
- Nach dem Push ein bis zwei Minuten warten und live mit `?cb=`-Cachebuster gegenprüfen;
  das GitHub-Pages-CDN cacht `catalog.json` separat von der HTML-Seite.
