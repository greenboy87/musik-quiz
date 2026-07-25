#!/bin/sh
# Erzeugt tailwind.css neu aus den in index.html verwendeten Klassen.
#
# WANN NÖTIG? Immer wenn in index.html NEUE Tailwind-Klassen verwendet werden,
# die vorher nirgends im Code standen (sonst fehlt deren Styling auf der Seite).
#
# Das Tailwind-Standalone-Binary (v3, kein Node nötig) einmalig laden:
#   curl -sL -o /usr/local/bin/tailwindcss \
#     https://github.com/tailwindlabs/tailwindcss/releases/download/v3.4.17/tailwindcss-macos-arm64
#   chmod +x /usr/local/bin/tailwindcss
#
# Dann hier im Projektordner ausführen:
#   ./build-css.sh

set -e
TAILWIND_BIN="${TAILWIND_BIN:-tailwindcss}"
"$TAILWIND_BIN" -c tailwind.config.js -i tailwind.input.css -o tailwind.css --minify
echo "tailwind.css wurde neu erzeugt."
