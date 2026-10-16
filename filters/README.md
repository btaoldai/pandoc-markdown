# filters/ — filtres Lua appliqués par pandoc entre la lecture et l'écriture

Un filtre Lua transforme l'arbre du document (AST) : il ne touche ni au fichier source ni au gabarit. Ordre d'application (fixé dans `defaults/*.yaml`) : `alertes.lua` puis `mermaid.lua`.

| Filtre | Entrée | Sortie | Dépendance |
|---|---|---|---|
| `alertes.lua` | pandoc < 3.2 : citation commençant par `[!NOTE]`… ; pandoc ≥ 3.2 : `Div` de classe `note`, `tip`, `important`, `warning`, `caution` (lecture native) | PDF : bloc Typst coloré à filet gauche ; HTML : `<div class="alerte alerte-note">` ; DOCX : citation ouverte par un libellé français en gras | aucune |
| `mermaid.lua` | Bloc de code `mermaid` | Image SVG (PDF, HTML) ou PNG (DOCX) dans `<dossier de la source>/sortie/mermaid/` | `mmdc` (mermaid-cli) ; sans lui, le bloc reste en code |
| `mermaid-config.json` | — | Thème et options passés à `mmdc` (`-c`) ; `htmlLabels: false` est **obligatoire** pour que Typst affiche le texte des nœuds | — |

Tester un filtre seul :

```bash
pandoc -f gfm -t native --lua-filter filters/alertes.lua exemples/demo.md | head -40
```

> attendu : l'arbre pandoc où la citation commence par `Strong [Str "Note :"]`.

Les deux formes sont gérées : vérifié avec pandoc 3.1.3 (citation) et 3.9.0.1 (`Div` natif).
