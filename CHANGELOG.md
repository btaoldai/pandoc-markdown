# Changelog

Format : [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/). Versions : [SemVer](https://semver.org/lang/fr/).

## [Unreleased]

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
