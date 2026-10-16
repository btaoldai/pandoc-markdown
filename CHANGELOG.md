# Changelog

Format : [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/). Versions : [SemVer](https://semver.org/lang/fr/).

## [Unreleased]

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
