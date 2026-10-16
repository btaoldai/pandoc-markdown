#!/usr/bin/env bash
# scripts/build.sh — Markdown → PDF | DOCX | HTML avec les réglages de defaults/
#
# Usage : scripts/build.sh <fichier.md> [pdf|docx|html|all]
# Sortie : sortie/<nom>.<ext>
# Prérequis : pandoc ≥ 3.1.2, typst (PDF), mmdc (schémas, facultatif)
set -euo pipefail

racine="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$racine"

entree="${1:?usage : scripts/build.sh <fichier.md> [pdf|docx|html|all]}"
format="${2:-all}"
nom="$(basename "${entree%.*}")"
mkdir -p sortie

construire() {
  local fmt="$1"
  echo "[build] ${nom}.${fmt}"
  pandoc -d "defaults/${fmt}.yaml" "$entree" -o "sortie/${nom}.${fmt}"
}

case "$format" in
  pdf|docx|html) construire "$format" ;;
  all) construire pdf; construire docx; construire html ;;
  *) echo "format inconnu : $format (pdf | docx | html | all)" >&2; exit 2 ;;
esac

ls -l "sortie/${nom}".* | sed 's/^/[build] /'
