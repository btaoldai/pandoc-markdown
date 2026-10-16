# ADR 0002 — Charte Forge & Lumière en version « papier »

**Statut :** accepté — 2026-10-16

## Contexte

La charte Forge & Lumière existe sous deux formes : les PPTX (fond sombre `0A1620`, top bar, darkHeader) et les DOCX de TP (fond blanc, titres abysse, encarts LEGENDE). Les documents produits ici (PDF, DOCX, HTML à partir de Markdown) sont lus à l'écran et imprimés, souvent denses en tableaux.

## Décision

Les trois gabarits (`templates/kit.typ`, `templates/reference.docx`, `templates/style.css`) portent la charte **papier**, calquée sur le helper DOCX canonique `_orchestration-cours/lib/helpers-forge-lumiere-docx.js` (jamais modifié, seulement lu) :

| Élément | Règle |
|---|---|
| Polices | Roboto (corps 11 pt, interligne 1,15), Roboto Mono (code 9,5 pt) ; livrées dans `templates/fonts/`, déclarées à Typst par `TYPST_FONT_PATHS` |
| Palette | abysse `132639`, cyan `00B4D8` / cyan foncé `0077A8` (liens), rouille `B85C38`, gris `EDF2F7`, vert `2F855A`, ambre `B7791F`, rouge `9B2C2C`, acier `A8A9AD` |
| Titres | niveau 1 abysse 15 pt + filet cyan ; niveau 2 rouille 13 pt ; niveau 3 abysse 11,5 pt |
| Code | bloc sur fond abysse, texte `E6F6EC`, monochrome (pas de coloration syntaxique) ; code en ligne sur fond gris |
| Tableaux | en-tête abysse / blanc, filets acier, lignes insécables |
| Encarts | alertes GitHub rendues en encart LEGENDE : filet gauche 4,5 pt, fond gris — NOTE abysse, TIP cyan, IMPORTANT rouille, WARNING ambre, CAUTION rouge ; libellés génériques (Note, Astuce, Important, Avertissement, Attention) |
| Page | A4, marges 1,6 × 1,8 cm, bandeau abysse + accent cyan au-dessus du titre, pied de page « titre — n / total » |
| Schémas | thème Mermaid clair dérivé de la palette (`filters/mermaid-config.json`), texte abysse, flèches cyan foncé |

## Conséquences

- Un `.md` produit un document reconnaissable comme un support Forge & Lumière sans générateur JS.
- Les libellés des encarts restent ceux des alertes GitHub : un `[!NOTE]` n'est pas un « PIÈGE », seule la couleur est partagée.
- Les polices pèsent 2,1 Mo dans le dépôt (Roboto : Apache 2.0 ; Roboto Mono : SIL OFL 1.1) : prix accepté pour un rendu identique partout.
- Toute évolution de la charte se fait d'abord dans le helper canonique, puis se reporte ici (même règle que pour les PPTX/DOCX).

## Alternatives écartées

- **Fond sombre comme les PPTX** : impression difficile, PDF lourds, tableaux denses moins lisibles.
- **Polices système** : Roboto absente de Windows et des conteneurs par défaut ; rendu variable.
- **Coloration syntaxique sur fond sombre** : thème à maintenir pour deux versions de pandoc ; la charte DOCX est monochrome.
