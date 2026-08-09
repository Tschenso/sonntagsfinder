# Pflegelog – Sonntagsfinder Würzburg

Nachvollziehbare Pflegehistorie der Seite. **Jeder Monats-Pflegelauf** (nach der
Pflege-Checkliste in der [README](README.md#pflege-checkliste-monatlich-ca-3060-minuten))
bekommt hier einen Eintrag: Datum, Katalogversion, `check-links`-Ergebnis und die
abgearbeiteten Reviews bzw. Befunde.

---

## Pflegeläufe (neueste zuerst)

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
