# Changelog

Format : [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/). Versions : [SemVer](https://semver.org/lang/fr/).

## [Unreleased]

## [0.3.0] — 2026-10-16 — G2 bis charte Forge & Lumière papier

### Ajouté
- `templates/fonts/` : Roboto (Apache 2.0) et Roboto Mono (SIL OFL 1.1) avec licences ; `TYPST_FONT_PATHS` positionné par les scripts.
- `docs/adr/0002` : charte Forge & Lumière en version papier (règles et alternatives écartées).

### Modifié
- `templates/kit.typ` : charte complète — Roboto 11 pt, titres abysse 15 pt à filet cyan / rouille 13 pt, liens cyan foncé sur gris, code monochrome sur fond abysse, tableaux à en-tête abysse, bandeau de titre, pied de page « titre — n / total », marges 1,6 × 1,8 cm ; fonction `encart()` exposée.
- `templates/reference.docx` : styles Word réglés à la charte (Title, Heading 1-9, Normal, Source Code, Verbatim Char, Hyperlink, marges).
- `templates/style.css` : même charte pour l'HTML.
- `filters/alertes.lua` : encarts aux couleurs LEGENDE (NOTE abysse, TIP cyan, IMPORTANT rouille, WARNING ambre, CAUTION rouge), dessin identique au helper DOCX.
- `filters/mermaid-config.json` : thème clair dérivé de la palette Forge & Lumière.
- `defaults/pdf.yaml` : plus d'option de coloration (Typst en monochrome via le gabarit ; pandoc 3.9 n'injecte rien par défaut).

### Vérifié
- `demo.md` avec pandoc 3.1.3 et 3.9.0.1 : Roboto et Roboto Mono embarquées dans le PDF ; aide-mémoire 15 pages, aucun tableau coupé.

## [0.2.0] — 2026-10-16 — G2 mise en page

### Ajouté
- Les sorties sont écrites **à côté de leur source** (`exemples/demo.md` → `exemples/sortie/demo.pdf`), schémas Mermaid compris ; `sortie/` reste ignoré par Git à tout niveau.
- Liens repérables en PDF et HTML : texte bleu sur fond gris léger (`kit.typ`, `style.css`).
- `filters/alertes.lua` : en sortie PDF, chaque alerte GitHub devient un bloc Typst coloré à filet gauche (mêmes couleurs que `style.css`), identique quelles que soient les versions de pandoc et de Typst.

### Modifié
- `templates/kit.typ` : pied de page « n / total » imposé, que pandoc transmette `none` (3.1) ou `"1"` (3.9) ; citations ordinaires rendues par une règle `show` explicite.
- `filters/mermaid-config.json` : `flowchart.wrappingWidth` à 320 px, les étiquettes de nœuds ne sont plus coupées en deux.

### Vérifié
- `demo.md` avec pandoc 3.1.3 et 3.9.0.1 ; aide-mémoire (15 p.) : aucun tableau coupé, aucune page quasi vide, numérotation complète.

## [0.1.2] — 2026-10-16 — retours du premier essai Windows

### Corrigé
- `filters/mermaid.lua` : sous Windows, `mmdc` est lancé via `cmd /c` (le binaire npm est un script `.cmd` que `pandoc.pipe` ne trouvait pas) ; le détail de l'erreur est affiché.
- `templates/kit.typ` : une seule police de repli, `Libertinus Serif` (embarquée dans Typst) — plus d'avertissement « unknown font family ».
- `defaults/html.yaml` : formules rendues en MathML (`html-math-method: mathml`) au lieu de la conversion « plain » qui échouait sur `\frac`, `\sqrt`.
- `scripts/build.ps1` : console en UTF-8, accents corrects dans les messages des filtres.

### Ajouté
- `.gitattributes` : LF normalisé dans le dépôt, CRLF pour `.ps1`, `.docx` en binaire.

## [0.1.1] — 2026-10-16 — compatibilité pandoc 3.9

### Modifié
- `templates/kit.typ` : devient un module Typst (`conf`) importé par le gabarit natif de pandoc via la variable `template`, au lieu de remplacer le gabarit (le partiel `definitions.typst` n'existe plus en 3.9) ; `conf` accepte les paramètres des versions 3.1 et 3.9.
- `filters/alertes.lua` : gère aussi la lecture native des alertes GitHub (`Div` de classe `warning`…, pandoc ≥ 3.2).
- `scripts/build.ps1` : enregistré en UTF-8 avec BOM (accents corrects sous PowerShell 5.1).

### Vérifié
- `demo.md` → PDF, DOCX, HTML avec pandoc 3.1.3 et 3.9.0.1 ; repli sans `mmdc` testé.

## [0.1.0] — 2026-10-16 — G1 squelette

### Ajouté
- `defaults/` : réglages pandoc pour PDF (Typst), DOCX, HTML autonome.
- `templates/` : gabarit Typst neutre `kit.typ`, `reference.docx` par défaut, `style.css`.
- `filters/` : `alertes.lua` (alertes GitHub → encadrés portables), `mermaid.lua` (schémas → SVG/PNG via mmdc).
- `scripts/` : `build.sh` et `build.ps1`, un point d'entrée par système.
- `exemples/` : `demo.md` (test de non-régression) et l'aide-mémoire Markdown (test de charge).
- `docs/adr/0001` : Typst plutôt que LaTeX.
