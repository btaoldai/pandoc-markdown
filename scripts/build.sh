#!/usr/bin/env bash
# scripts/build.sh — Markdown → PDF | DOCX | HTML avec les réglages de defaults/
#
# Usage : scripts/build.sh <fichier.md> [pdf|docx|html|all]
# Sortie : <dossier du fichier>/sortie/<nom>.<ext>  (ex. exemples/demo.md → exemples/sortie/demo.pdf)
# Prérequis : pandoc ≥ 3.1.2, typst (PDF), mmdc (schémas, facultatif)
set -euo pipefail

racine="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$racine"

entree="${1:?usage : scripts/build.sh <fichier.md> [pdf|docx|html|all]}"
format="${2:-all}"
nom="$(basename "${entree%.*}")"
dossier="$(dirname "$entree")/sortie"
mkdir -p "$dossier"
# Les schémas Mermaid rendus vont à côté des sorties (lu par filters/mermaid.lua)
export PANDOC_MERMAID_DIR="$dossier/mermaid"
# Polices de la charte (Roboto, Roboto Mono) livrées avec le projet, lues par Typst
export TYPST_FONT_PATHS="$racine/templates/fonts"

construire() {
  local fmt="$1"
  echo "[build] ${dossier}/${nom}.${fmt}"
  pandoc -d "defaults/${fmt}.yaml" "$entree" -o "${dossier}/${nom}.${fmt}"
}

case "$format" in
  pdf|docx|html) construire "$format" ;;
  all) construire pdf; construire docx; construire html ;;
  *) echo "format inconnu : $format (pdf | docx | html | all)" >&2; exit 2 ;;
esac

ls -l "${dossier}/${nom}".* | sed 's/^/[build] /'
