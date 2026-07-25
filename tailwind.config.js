/** Statische Tailwind-Konfiguration (ersetzt das frühere Play-CDN).
 *  Nach Änderungen an Klassen in index.html muss tailwind.css neu erzeugt
 *  werden - siehe build-css.sh */
module.exports = {
  content: ["./index.html"],
  theme: { extend: {} },
};
