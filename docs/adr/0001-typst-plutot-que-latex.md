# ADR 0001 — Typst comme moteur PDF plutôt que LaTeX

**Statut :** accepté — 2026-10-16

## Contexte

Pandoc produit un PDF en passant par un moteur externe. Les choix usuels : LaTeX (`pdflatex`, `xelatex`, `lualatex`), `wkhtmltopdf` ou un navigateur (HTML → PDF), Typst (depuis pandoc 3.1.2).

## Décision

Le moteur PDF du projet est **Typst** (`pdf-engine: typst` dans `defaults/pdf.yaml`), avec un gabarit propre (`templates/kit.typ`) qui conserve l'interface `conf` du gabarit pandoc par défaut.

## Conséquences

- Installation d'un seul binaire (`winget install Typst.Typst`, `cargo install typst-cli`) au lieu d'une distribution TeX de plusieurs gigaoctets.
- Compilation en une seconde environ pour un document de 20 pages, contre 10 à 30 s avec LaTeX.
- Gabarit lisible et versionnable (`kit.typ`), modifiable sans connaître TeX.
- Pandoc ≥ 3.1.2 requis ; les versions plus anciennes (2.x des dépôts Linux) ne connaissent pas Typst.
- Les polices doivent être installées sur la machine ; les emoji nécessitent une police emoji.
- Mermaid n'est rendu par aucun moteur : pré-rendu en image par `filters/mermaid.lua` (mermaid-cli).

## Alternatives écartées

- **LaTeX** : rendu de référence, mais installation lourde, compilation lente, gabarits difficiles à maintenir.
- **HTML → PDF (navigateur)** : fidèle au CSS, mais dépend d'un navigateur sans interface et gère mal les sauts de page et la numérotation.
