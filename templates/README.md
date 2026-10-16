# templates/ — gabarits de mise en page, un par format

| Fichier | Format | Rôle |
|---|---|---|
| `kit.typ` | PDF | **Module** Typst exportant `conf`, importé par le gabarit natif de pandoc (variable `template` de `defaults/pdf.yaml`) : A4, français, numéro de page « n / total », tableaux et figures insécables, blocs de code encadrés. `conf` accepte l'union des paramètres envoyés par pandoc 3.1 et 3.9 |
| `reference.docx` | DOCX | Document de référence pandoc : les styles Word (Titre 1, Normal, Code source…) y sont lus, le contenu est ignoré. Version par défaut de pandoc 3.1.3 (`pandoc -o reference.docx --print-default-data-file reference.docx`) |
| `style.css` | HTML | Feuille neutre, imprimable en A4, classes `.alerte-*` pour les alertes GitHub |

Un gabarit décrit **l'apparence**, jamais le contenu. La charte Forge & Lumière viendra remplacer ces trois fichiers (G2 bis) sans changer les réglages de `defaults/` : même interface (`conf` pour Typst, mêmes noms de styles Word, mêmes classes CSS).

Modifier `reference.docx` : l'ouvrir dans Word ou LibreOffice, changer les **styles** (pas le texte), enregistrer.
