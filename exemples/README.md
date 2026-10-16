# exemples/ — fichiers d'essai de la chaîne

| Fichier | Rôle |
|---|---|
| `demo.md` | Petit document qui exerce chaque construction prise en charge (alerte, schéma, tableau, formule, note). C'est le test de non-régression : il doit passer dans les trois formats après tout changement de `defaults/`, `templates/` ou `filters/` |
| `aide-memoire-markdown.md` | Document long (≈ 670 lignes, 32 tableaux, emoji) : test de charge pour la mise en page |

```bash
scripts/build.sh exemples/demo.md all
```

> attendu : `sortie/demo.pdf`, `sortie/demo.docx`, `sortie/demo.html`, et `sortie/mermaid/` contenant le schéma rendu.
