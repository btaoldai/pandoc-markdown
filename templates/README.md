# templates/ — gabarits de mise en page, un par format, charte Forge & Lumière « papier »

| Fichier | Format | Rôle |
|---|---|---|
| `kit.typ` | PDF | **Module** Typst exportant `conf`, importé par le gabarit natif de pandoc (variable `template` de `defaults/pdf.yaml`). Porte la charte : Roboto, palette, titres, encarts, code sur fond abysse, tableaux, bandeau, pied de page. `conf` accepte l'union des paramètres envoyés par pandoc 3.1 et 3.9 |
| `reference.docx` | DOCX | Document de référence pandoc : seuls ses **styles** comptent (Title, Heading 1-4, Normal, Source Code, Verbatim Char, Hyperlink…), réglés à la charte ; le contenu est ignoré |
| `style.css` | HTML | Même charte pour la page HTML autonome, classes `.alerte-*` pour les encarts |
| `fonts/` | PDF | Roboto (Regular, Bold, Italic, BoldItalic, Medium — Apache 2.0) et Roboto Mono (Regular, Bold, Italic, BoldItalic — SIL OFL 1.1), lues par Typst via `TYPST_FONT_PATHS` que les scripts positionnent. Licences incluses |

Source de la charte : `Cours-presta-informatique/_orchestration-cours/lib/helpers-forge-lumiere-docx.js` (helper canonique, lu, jamais modifié) — décision et table des règles dans [`docs/adr/0002`](../docs/adr/0002-charte-forge-lumiere-papier.md).

Un gabarit décrit **l'apparence**, jamais le contenu. Modifier `reference.docx` : l'ouvrir dans Word ou LibreOffice, changer les **styles** (pas le texte), enregistrer. Vérifier ensuite `scripts/build.sh exemples/demo.md docx`.

DOCX et HTML utilisent Roboto si elle est installée sur la machine du lecteur, sinon la police de repli (Segoe UI / Arial) : seul le PDF embarque les polices.
