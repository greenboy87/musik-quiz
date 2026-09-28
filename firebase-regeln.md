# Firebase-Regeln für den Cloud-Sync (einmalig)

Der Cloud-Sync legt den Spielstand verschlüsselt unter `tresor/<id>` ab — im
**bestehenden** Projekt `greenboys-scoreboard`, direkt neben `rooms`. Solange die
Freigabe fehlt, meldet die Seite „Die Firebase-Regeln geben den Pfad `tresor`
noch nicht frei".

School-Tool ist davon nicht betroffen: Das liegt in einem eigenen Projekt
(`school-tool-cbbf9`) und wird hier nicht angefasst.

## So geht's

**1.** <https://console.firebase.google.com> → Projekt **greenboys-scoreboard** →
**Realtime Database** → Reiter **Regeln**.

**2.** Alles im Editor markieren (Cmd+A) und durch den **vollständigen** Text unten
ersetzen. Er enthält den `rooms`-Block bereits — der muss erhalten bleiben, sonst
funktioniert das Quiz selbst nicht mehr.

```json
{
  "rules": {
    "rooms": {
      "$roomCode": {
        ".read": true,
        ".write": true
      }
    },
    "tresor": {
      "$id": {
        ".read": true,
        ".write": true,
        "chiffre": { ".validate": "newData.isString() && newData.val().length <= 6000000" },
        "iv":      { ".validate": "newData.isString() && newData.val().length <= 64" },
        "salz":    { ".validate": "newData.isString() && newData.val().length <= 64" },
        "stand":   { ".validate": "newData.isNumber()" },
        "geraet":  { ".validate": "newData.isString() && newData.val().length <= 32" },
        "$andere": { ".validate": false }
      }
    }
  }
}
```

> **Warum der ganze Text und nicht nur der `tresor`-Teil?** Eine frühere Fassung
> dieser Anleitung sagte „hinter die schließende Klammer des `rooms`-Blocks ein
> Komma setzen und nur den `tresor`-Teil einfügen". Das verlangt, in fremdem JSON
> die richtige von mehreren schließenden Klammern zu treffen — beim ersten Versuch
> stand danach nur noch der `tresor`-Block im Editor, `rooms` war weg. Der Fehler
> blieb folgenlos, weil er unveröffentlicht war und „Verwerfen" ihn zurückholt.
> Sollte sich der `rooms`-Block je ändern, hier im Text mit anpassen.

**3.** **Veröffentlichen**. Fertig — in der Lehrer-Ansicht einmal Cmd+Shift+R.

**Sicherheitsnetz:** Solange oben „Unveröffentlichte Änderungen" steht, ist noch
nichts scharf geschaltet, und **Verwerfen** holt die laufende Fassung zurück. Der
Reiter **Sicherungen** führt zusätzlich zu den früheren Regel-Versionen.

## Warum `.read: true` hier vertretbar ist

`$id` ist kein Name, den man erraten kann: Er ist der SHA-256-Wert des
Sync-Passworts (mit eigenem Zusatz), 32 Hex-Zeichen lang. Und selbst wer ihn
hätte, fände dort nur `chiffre` — AES-GCM-verschlüsselt, Schlüssel per PBKDF2
(250 000 Runden) aus dem Sync-Passwort abgeleitet. Klassennamen, Teamnamen und
Punkte verlassen das Gerät nie im Klartext. Weder Google noch sonst jemand ohne
das Passwort kann sie lesen.

Das ist ein anderer Schutz als beim Quiz-Raum (`rooms`): Dort liegen die Daten
unverschlüsselt, sind dafür aber flüchtig und enthalten nur die laufende Runde.

`"$andere": { ".validate": false }` sorgt dafür, dass unter einem Tresor-Knoten
ausschließlich die fünf genannten Felder landen können — niemand kann den Pfad
als beliebigen Datenspeicher zweckentfremden.

## Was passiert, wenn das Passwort weg ist

Dann sind die Daten in der Cloud verloren. Es gibt bewusst keine Hintertür — das
ist der Sinn echter Verschlüsselung. Die Sicherung über „Sichern als Datei"
bleibt deshalb weiter sinnvoll als zweites Standbein.
