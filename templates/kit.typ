// templates/kit.typ — module Typst exportant `conf`, charte Forge & Lumière, version « papier ».
// Importé par le gabarit natif de pandoc (variable `template` dans defaults/pdf.yaml).
// Source de la charte : _orchestration-cours/lib/helpers-forge-lumiere-docx.js (canonique, jamais
// modifié ici) — polices Roboto / Roboto Mono, palette abysse-cyan-rouille-gris-vert-ambre-rouge,
// titres 15/13 pt, corps 11 pt interligne 1,15, marges 1,6 × 1,8 cm, code sur fond abysse,
// tableaux à en-tête abysse. Compatible pandoc 3.1.x et 3.9 (union des paramètres de `conf`).
// Les polices sont dans templates/fonts/ ; les scripts les déclarent via TYPST_FONT_PATHS.

// ── Palette Forge & Lumière ───────────────────────────────────────────────
#let abysse  = rgb("#132639")
#let cyan    = rgb("#00B4D8")
#let cyan-f  = rgb("#0077A8")   // cyan foncé : liens
#let rouille = rgb("#B85C38")
#let gris    = rgb("#EDF2F7")
#let vert    = rgb("#2F855A")
#let ambre   = rgb("#B7791F")
#let rouge   = rgb("#9B2C2C")
#let acier   = rgb("#A8A9AD")
#let encre2  = rgb("#555555")   // texte secondaire
#let code-tx = rgb("#E6F6EC")   // texte des blocs de code sur fond abysse

#let police      = ("Roboto", "Liberation Sans", "DejaVu Sans")
#let police-mono = ("Roboto Mono", "Consolas", "DejaVu Sans Mono", "Liberation Mono")

#let content-to-string(content) = {
  if content == none { "" }
  else if type(content) == str { content }
  else if content.has("text") { content.text }
  else if content.has("children") { content.children.map(content-to-string).join("") }
  else if content.has("body") { content-to-string(content.body) }
  else { "" }
}

// Encart Forge & Lumière : filet gauche épais de la couleur du type, cadre fin, fond gris.
// Utilisé par filters/alertes.lua (bloc Typst brut) ; exposé pour un usage direct.
#let encart(couleur, libelle, corps) = block(
  width: 100%, fill: gris, inset: (left: 10pt, right: 8pt, y: 7pt), breakable: false,
  stroke: (left: 4.5pt + couleur, top: 0.5pt + couleur, bottom: 0.5pt + couleur, right: 0.5pt + couleur),
)[
  #text(fill: couleur, weight: "bold", size: 10pt)[#upper(libelle)]
  #v(2pt)
  #set text(fill: abysse, size: 10.5pt)
  #corps
]

#let conf(
  title: none, subtitle: none, authors: (), keywords: (), date: none,
  abstract-title: none, abstract: none, thanks: none, cols: 1,
  margin: (x: 1.8cm, y: 1.6cm), paper: "a4", lang: "fr", region: "FR",
  font: none, fontsize: 11pt, mathfont: none, codefont: none, linestretch: 1,
  sectionnumbering: none, linkcolor: none, citecolor: none, filecolor: none,
  pagenumbering: "1 / 1", doc,
) = {
  let titre-txt = if title == none { "" } else { content-to-string(title) }
  set document(title: titre-txt)
  set page(
    paper: paper, margin: margin, columns: cols,
    footer: context [
      #set text(size: 8.5pt, fill: encre2)
      #grid(columns: (1fr, auto), align: (left, right),
        [#titre-txt],
        [#text(fill: abysse, weight: "bold")[#counter(page).display("1 / 1", both: true)]])
    ],
  )
  set par(justify: true, leading: 0.72em * linestretch, spacing: 0.9em)
  set text(lang: lang, region: region, size: fontsize, fill: abysse,
    font: if font != none and font != () { font } else { police })
  show math.equation: set text(font: mathfont) if mathfont != none
  set heading(numbering: sectionnumbering)

  // Titres : niveau 1 abysse 15 pt + filet cyan ; niveau 2 rouille 13 pt ; niveau 3 abysse 11,5 pt
  show heading.where(level: 1): it => block(above: 1.6em, below: 0.9em, width: 100%)[
    #text(size: 15pt, weight: "bold", fill: abysse)[#it.body]
    #v(-4pt) #line(length: 100%, stroke: 1.2pt + cyan)
  ]
  show heading.where(level: 2): set text(size: 13pt, weight: "bold", fill: rouille)
  show heading.where(level: 2): set block(above: 1.4em, below: 0.7em)
  show heading.where(level: 3): set text(size: 11.5pt, weight: "bold", fill: abysse)
  show heading.where(level: 3): set block(above: 1.2em, below: 0.6em)
  show heading.where(level: 4): set text(size: 11pt, weight: "bold", fill: encre2)

  // Liens : cyan foncé sur fond gris léger (repérables à l'écran et imprimés)
  show link: it => box(fill: gris, inset: (x: 2pt, y: 1pt), radius: 2pt, outset: (y: 1pt),
    text(fill: if linkcolor != none { rgb(content-to-string(linkcolor)) } else { cyan-f }, it))

  // Code : blocs sur fond abysse, texte clair, Roboto Mono 9,5 pt, sans coloration (charte) ;
  // code dans la phrase sur fond gris
  show raw: set text(font: if codefont != none { codefont } else { police-mono }, size: 9.5pt)
  show raw.where(block: true): set raw(theme: none)
  show raw.where(block: true): it => block(width: 100%, fill: abysse, inset: 8pt, radius: 0pt,
    stroke: 0.5pt + abysse, text(fill: code-tx, it))
  show raw.where(block: false): it => box(fill: gris, inset: (x: 2pt, y: 0pt), outset: (y: 2pt), radius: 2pt, it)

  // Tableaux : en-tête abysse / blanc, filets acier, insécables
  show table: set block(breakable: false)
  set table(stroke: 0.5pt + acier, inset: (x: 6pt, y: 4pt),
    fill: (x, y) => if y == 0 { abysse } else { none })
  show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 9.5pt)
  show table.cell: set text(size: 9.5pt)
  show figure: set block(breakable: false)

  // Citations ordinaires : filet gris, texte secondaire
  show quote.where(block: true): it => block(inset: (left: 1em, y: 0.3em), width: 100%,
    stroke: (left: 2pt + acier), text(fill: encre2, it.body))

  // Bloc titre : barre abysse + accent cyan, titre 17 pt, sous-titre italique
  if title != none {
    block(width: 100%, above: 0pt, below: 1.4em)[
      #block(width: 100%, height: 5pt, fill: abysse)
      #block(width: 22%, height: 2.5pt, fill: cyan, above: 0pt)
      #v(10pt)
      #text(size: 17pt, weight: "bold", fill: abysse)[#title]
      #if subtitle != none { v(2pt); text(size: 11pt, style: "italic", fill: encre2)[#subtitle] }
      #if authors != none and authors != () {
        v(4pt); text(size: 10pt, fill: encre2)[#authors.map(a => content-to-string(a.name)).join(", ")]
      }
      #if date != none { v(2pt); text(size: 10pt, fill: encre2)[#date] }
    ]
  }
  if abstract != none {
    block(inset: (x: 1em, y: 0.6em), fill: gris, width: 100%)[
      #text(weight: "bold", fill: abysse)[#if abstract-title == none [Résumé] else [#abstract-title]] #h(1em) #abstract]
  }
  doc
}
