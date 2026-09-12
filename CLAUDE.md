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
