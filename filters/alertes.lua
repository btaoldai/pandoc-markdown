-- filters/alertes.lua — rend portables les alertes GitHub (> [!NOTE] …)
--
-- Deux formes d'entrée, selon la version de pandoc :
--   • pandoc < 3.2 : simple citation dont la première ligne est le texte « [!NOTE] » ;
--   • pandoc ≥ 3.2 : Div de classe note|tip|important|warning|caution contenant un
--     Div « title » puis le corps (lecture native des alertes GitHub).
-- Sortie, identique dans les deux cas : en PDF (Typst) un bloc coloré à filet gauche ;
-- en HTML un <div class="alerte alerte-note"> stylé par style.css ; en DOCX et ailleurs
-- une citation ouverte par un libellé français en gras.
-- Un bloc non reconnu est rendu tel quel (jamais d'erreur).

local libelles = {
  note = "Note", tip = "Astuce", important = "Important",
  warning = "Avertissement", caution = "Attention",
}

-- Couleurs identiques à templates/style.css (palette des alertes GitHub)
local couleurs = {
  note = "0969da", tip = "1a7f37", important = "8250df",
  warning = "9a6700", caution = "cf222e",
}

local function sortie(type_, corps)
  local titre = pandoc.Para({ pandoc.Strong({ pandoc.Str(libelles[type_] .. " :") }) })
  if FORMAT:match("html") then
    table.insert(corps, 1, titre)
    return pandoc.Div(corps, pandoc.Attr("", { "alerte", "alerte-" .. type_ }))
  end
  if FORMAT:match("typst") then
    -- Bloc Typst explicite : rendu identique quelles que soient les versions de pandoc et Typst
    local corps_typst = pandoc.write(pandoc.Pandoc(corps), "typst")
    local raw = string.format(
      '#block(width: 100%%, inset: (x: 10pt, y: 8pt), radius: 3pt, fill: luma(248), ' ..
      'stroke: (left: 3pt + rgb("#%s")), breakable: false)[\n#text(fill: rgb("#%s"), weight: "bold")[%s]\n\n%s]',
      couleurs[type_], couleurs[type_], libelles[type_], corps_typst)
    return pandoc.RawBlock("typst", raw)
  end
  table.insert(corps, 1, titre)
  return pandoc.BlockQuote(corps)
end

-- Forme pandoc ≥ 3.2
function Div(el)
  local type_ = nil
  for _, c in ipairs(el.classes) do if libelles[c] then type_ = c end end
  if not type_ then return nil end
  local corps = {}
  for i, b in ipairs(el.content) do
    local est_titre = (i == 1 and b.t == "Div" and b.classes:includes("title"))
    if not est_titre then table.insert(corps, b) end
  end
  return sortie(type_, corps)
end

-- Forme pandoc < 3.2
function BlockQuote(el)
  local premier = el.content[1]
  if not premier or premier.t ~= "Para" then return nil end
  local s = premier.content[1]
  if not (s and s.t == "Str") then return nil end
  local mot = s.text:match("^%[!(%u+)%]$")
  if not mot or not libelles[mot:lower()] then return nil end
  table.remove(premier.content, 1)
  while premier.content[1] and (premier.content[1].t == "SoftBreak"
        or premier.content[1].t == "Space" or premier.content[1].t == "LineBreak") do
    table.remove(premier.content, 1)
  end
  local corps = {}
  for i, b in ipairs(el.content) do
    if not (i == 1 and #premier.content == 0) then table.insert(corps, b) end
  end
  return sortie(mot:lower(), corps)
end
