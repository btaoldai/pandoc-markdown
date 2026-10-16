# defaults/ — un fichier de réglages pandoc par format

Chaque fichier `.yaml` est un « defaults file » pandoc : il remplace une longue ligne de commande par `pandoc -d defaults/<format>.yaml`. Un format = un fichier ; ajouter un format = ajouter un fichier, sans toucher aux scripts.

| Fichier | Produit | Moteur | Gabarit |
|---|---|---|---|
| `pdf.yaml` | PDF | Typst (`pdf-engine: typst`) | `templates/kit.typ` |
| `docx.yaml` | Word | writer docx de pandoc | `templates/reference.docx` |
| `html.yaml` | HTML autonome (CSS et images incluses) | writer html5 | `templates/style.css` |

Les chemins sont relatifs à la **racine du projet** : lancer pandoc depuis cette racine (ce que font `scripts/build.sh` et `scripts/build.ps1`).

Réglages communs : lecture en `gfm` (tableaux, cases à cocher, notes de bas de page, barré), langue `fr`, filtres `filters/alertes.lua` puis `filters/mermaid.lua`, `resource-path` pour retrouver les images depuis `exemples/`.
