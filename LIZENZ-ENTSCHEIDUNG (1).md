# Lizenz-Entscheidung (offen – vor dem ersten Push entscheiden oder bewusst vertagen)

Das Repo enthält zwei verschiedene Arten von Werk, die üblicherweise getrennt lizenziert
werden. Ohne LICENSE-Datei gilt automatisch „alle Rechte vorbehalten" – auch das ist
zulässig für den Start, verhindert aber legale Weiternutzung durch Dritte.

## Empfehlung: Doppellizenz

| Was | Empfohlene Lizenz | Warum |
|---|---|---|
| **Daten** (`catalog.json`, `events.json`, Redaktionstexte) | **CC BY 4.0** | Andere Einrichtungen (Gemeinden, Träger, Familienzentren) dürfen die Sammlung übernehmen und anpassen, müssen aber „Sonntagsfinder Würzburg" als Quelle nennen. Namensnennung schützt die redaktionelle Arbeit und bringt Rückverlinkung. |
| **Code** (`index.html`) | **MIT** | Maximal einfach; jede andere Stadt kann die Seite mit eigenem Katalog nachbauen. Der Code ist bewusst generisch – sein Wert liegt in der Verbreitung, nicht in der Exklusivität. |

## Alternativen (falls anders gewollt)

- **Alles CC BY 4.0:** einfacher (eine Lizenz), aber für Code unüblich und juristisch
  weniger passgenau (CC rät selbst von CC-Lizenzen für Software ab).
- **Daten CC BY-SA 4.0:** erzwingt, dass Übernahmen ebenfalls offen bleiben („Copyleft").
  Sinnvoll, wenn kommerzielle Einhegung verhindert werden soll; senkt aber die
  Übernahmebereitschaft von Kommunen.
- **Vorerst keine Lizenz:** Repo darf öffentlich sein, Dritte dürfen lesen, aber nicht
  weiterverwenden. Legitim als Übergang; Entscheidung dann per späterem Commit.

## Nicht vergessen (unabhängig von der Wahl)

- Die **OSM-Attribution (ODbL)** für Entfernungsangaben bleibt in jedem Fall bestehen
  (steht bereits im Footer und in der README).
- Die verlinkten Quellentexte (Betreiber, Stadt, Landkreis) sind **nicht** Teil der
  Lizenz – lizenziert werden nur eigene Zusammenfassungen und Strukturdaten.

## Umsetzung nach Entscheidung (ein Commit)

1. `LICENSE`-Datei mit MIT-Text anlegen (Copyright-Zeile: Jahr + Name/Projektname).
2. `LICENSE-DATA`-Datei mit Verweis auf CC BY 4.0 anlegen
   (https://creativecommons.org/licenses/by/4.0/deed.de).
3. In der README einen Abschnitt „Lizenz" ergänzen: „Code: MIT · Daten: CC BY 4.0 –
   Namensnennung: ‚Sonntagsfinder Würzburg'".
4. Diese Datei (`LIZENZ-ENTSCHEIDUNG.md`) löschen oder als entschieden markieren.
