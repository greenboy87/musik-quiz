# Hinweise für Claude Code

## Nicht in einen Cloud-Ordner legen

Dieses Repository darf nicht in einem synchronisierten Ordner liegen (iCloud
Drive, OneDrive, Dropbox). Solche Dienste benennen bei Konflikten um, statt
zusammenzuführen, und beschädigen dabei `.git`: Es entstehen Konfliktkopien wie
`refs/remotes/origin/main 2`, während die echte Ref-Datei verschwindet.
`git fetch` läuft dann stillschweigend ins Leere und `git status` meldet einen
Stand, der nicht stimmt — im schlimmsten Fall „ahead", obwohl der Ordner in
Wahrheit veraltet ist.

## Dem lokalen Stand nicht ungeprüft glauben

Vor jedem Urteil über den Stand eines Ordners erst abgleichen: `git fetch`, oder
`git ls-remote origin main` — das schreibt nichts und funktioniert auch in einem
beschädigten `.git`. Und bevor ein Ordner gelöscht oder verschoben wird, prüfen,
ob dort Commits liegen, die es auf GitHub noch nicht gibt.

## Abgleich zwischen mehreren Rechnern

Läuft über GitHub, nicht über Dateisynchronisation: `git pull` vor dem Arbeiten,
`git commit` und `git push` danach.

## Tailwind: auf diesem Mac nur vorhandene Klassen verwenden

`tailwind.css` ist vorgeneriert. Das Standalone-Binary ist hier **nicht**
installiert (und Node auch nicht), `./build-css.sh` läuft also nicht. Eine neue
Tailwind-Klasse, die noch nirgends im Code steht, bleibt deshalb wirkungslos —
vor dem Einsatz einer Klasse prüfen, ob sie in `tailwind.css` vorkommt, sonst
eine vorhandene Abstufung nehmen (z. B. `text-emerald-400` statt
`text-emerald-300`).

## Cloud-Sync liegt im Firebase-Projekt greenboys-scoreboard

Der verschlüsselte Spielstand liegt unter `tresor/<id>`, direkt neben `rooms` im
selben Projekt. School-Tool hat ein eigenes Projekt (`school-tool-cbbf9`) und ist
davon nicht berührt. Die nötige Regel-Freigabe steht in `firebase-regeln.md` —
den `rooms`-Block dabei niemals ersetzen.

## Tonprobleme: erst den Browser neu starten, dann suchen

Die Tonausgabe des Browsers kann in einen Zustand geraten, aus dem ein
Neuladen der Seite nicht herausführt — nur ein vollständiger Neustart des
Browsers. Das ist hier zweimal passiert: einmal blieb Safari komplett stumm,
obwohl `AudioContext.state` „running" meldete und die Uhr lief; einmal kam in
Chrome alles Hörbare genau einen Takt nach der Anzeige, auch nach Reload und
mit nachweislich aktueller Fassung (Zeitstempel in der Fußzeile geprüft).

Beide Male war der Code nicht die Ursache. Bevor also an der Taktung
geschraubt wird: Browser beenden und neu öffnen. Erst wenn der Fehler das
überlebt, lohnt die Suche im Code — sonst jagt man einem Zustand hinterher,
der sich beim nächsten Start von selbst erledigt.
