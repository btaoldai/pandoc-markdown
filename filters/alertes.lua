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

-- Couleurs Forge & Lumière (LEGENDE), identiques à templates/kit.typ et templates/style.css :
-- NOTE abysse (ton PIÈGE), TIP cyan (POUR ALLER PLUS LOIN), IMPORTANT rouille (DÉMARCHE),
-- WARNING ambre (PREUVE), CAUTION rouge (erreurs). Les libellés restent génériques.
local couleurs = {
  note = "132639", tip = "00B4D8", important = "B85C38",
  warning = "B7791F", caution = "9B2C2C",
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
    -- Encart de la charte : filet gauche épais, cadre fin, fond gris (même dessin que le helper DOCX)
    local c = 'rgb("#' .. couleurs[type_] .. '")'
    local raw = string.format(
      '#block(width: 100%%, fill: rgb("#EDF2F7"), inset: (left: 10pt, right: 8pt, y: 7pt), breakable: false, ' ..
      'stroke: (left: 4.5pt + %s, top: 0.5pt + %s, bottom: 0.5pt + %s, right: 0.5pt + %s))[\n' ..
      '#text(fill: %s, weight: "bold", size: 10pt)[%s]\n#v(2pt)\n#set text(fill: rgb("#132639"), size: 10.5pt)\n%s]',
      c, c, c, c, c, string.upper(libelles[type_]), corps_typst)
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
