// templates/kit.typ — module Typst exportant `conf`, importé par le gabarit natif de pandoc
// (variable `template` dans defaults/pdf.yaml : `#import "templates/kit.typ": conf`).
// Compatible pandoc 3.1.x et 3.9 : `conf` accepte tous les paramètres que l'un ou l'autre
// envoie. Réglages : A4, français, numéro de page « n / total », tableaux et figures
// insécables, blocs de code encadrés. G2 bis : la charte Forge & Lumière remplacera ce
// fichier en conservant la même signature.

#let content-to-string(content) = {
  if content == none { "" }
  else if type(content) == str { content }
  else if content.has("text") { content.text }
  else if content.has("children") { content.children.map(content-to-string).join("") }
  else if content.has("body") { content-to-string(content.body) }
  else { "" }
}

#let conf(
  title: none,
  subtitle: none,
  authors: (),
  keywords: (),
  date: none,
  abstract-title: none,
  abstract: none,
  thanks: none,
  cols: 1,
  margin: (x: 2cm, y: 2cm),
  paper: "a4",
  lang: "fr",
  region: "FR",
  // Liste de repli : Typst prend la première police installée ; -V mainfont la remplace
  font: ("Libertinus Serif", "Linux Libertine", "Noto Serif", "DejaVu Serif"),
  fontsize: 10.5pt,
  mathfont: none,
  codefont: none,
  linestretch: 1,
  sectionnumbering: none,
  linkcolor: none,
  citecolor: none,
  filecolor: none,
  pagenumbering: "1 / 1",
  doc,
) = {
  set document(title: if title == none { "" } else { content-to-string(title) })
  set page(
    paper: paper,
    margin: margin,
    numbering: if pagenumbering == none { "1 / 1" } else { pagenumbering },
    number-align: center,
    columns: cols,
  )
  set par(justify: true, leading: linestretch * 0.65em)
  set text(lang: lang, region: region, size: fontsize)
  set text(font: font) if font != none and font != ()
  show math.equation: set text(font: mathfont) if mathfont != none
  show raw: set text(font: codefont) if codefont != none
  set heading(numbering: sectionnumbering)
  show link: set text(fill: rgb(content-to-string(linkcolor))) if linkcolor != none

  // Aération : pas de tableau ni de figure coupé entre deux pages
  show table: set block(breakable: false)
  show figure: set block(breakable: false)
  show table: set text(size: 0.9em)
  set table(stroke: 0.5pt + luma(160), inset: 5pt)

  // Blocs de code : fond clair, bordure fine, pleine largeur
  show raw.where(block: true): set block(fill: luma(246), stroke: 0.5pt + luma(200), inset: 8pt, radius: 3pt, width: 100%)
  show raw: set text(size: 0.9em)

  // Titres
  show heading: set block(above: 1.4em, below: 0.8em)
  show heading.where(level: 1): set text(size: 1.6em)
  show heading.where(level: 2): set text(size: 1.3em)

  // Encadrés d'alerte (filters/alertes.lua produit une citation ouverte par un libellé en gras)
  show quote.where(block: true): set block(stroke: (left: 2pt + luma(170)), inset: (left: 1em, y: 0.4em))

  if title != none {
    align(center)[#block(inset: (y: 1.5em))[
      #text(weight: "bold", size: 1.6em)[#title]
      #if subtitle != none { parbreak(); text(weight: "bold", size: 1.2em)[#subtitle] }
    ]]
  }
  if authors != none and authors != () {
    let ncols = calc.min(authors.len(), 3)
    grid(columns: (1fr,) * ncols, row-gutter: 1.5em,
      ..authors.map(a => align(center)[#a.name \ #a.affiliation \ #a.email]))
  }
  if date != none { align(center)[#block(inset: 1em)[#date]] }
  if abstract != none {
    block(inset: 2em)[#text(weight: "semibold")[#if abstract-title == none [Résumé] else [#abstract-title]] #h(1em) #abstract]
  }
  doc
}
