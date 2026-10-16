# scripts/ — un point d'entrée par système

| Script | Système | Usage |
|---|---|---|
| `build.sh` | Linux, macOS, Git Bash | `scripts/build.sh exemples/demo.md [pdf\|docx\|html\|all]` |
| `build.ps1` | Windows PowerShell | `.\scripts\build.ps1 exemples\demo.md [-Format pdf\|docx\|html\|all]` |

Les deux font la même chose : se placer à la racine du projet, créer `sortie/`, appeler `pandoc -d defaults/<format>.yaml`. Toute la logique est dans `defaults/` ; les scripts ne contiennent aucun réglage.

> attendu :
> `[build] demo.pdf` · `[build] demo.docx` · `[build] demo.html` puis la liste des fichiers produits dans `sortie/`.

Sans script, la commande équivalente :

```bash
pandoc -d defaults/pdf.yaml exemples/demo.md -o sortie/demo.pdf
```
