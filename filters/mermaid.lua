-- filters/mermaid.lua — rend les blocs ```mermaid en image avec mermaid-cli (mmdc)
--
-- Sortie : SVG pour PDF (Typst) et HTML, PNG pour DOCX, dans le dossier PANDOC_MERMAID_DIR
-- (les scripts le fixent à <dossier de la source>/sortie/mermaid ; défaut : sortie/mermaid). Thème et options Mermaid
-- dans filters/mermaid-config.json (htmlLabels désactivé : obligatoire pour Typst). Les images sont écrites dans
-- <dossier>/<empreinte>.<ext> (empreinte SHA-1 du bloc : un schéma inchangé
-- n'est pas re-rendu). Sans mmdc, le bloc est conservé en code et un message
-- l'indique sur la sortie d'erreur : la génération continue.
--
-- Variables d'environnement reconnues (noms seulement, voir .env.example) :
--   MERMAID_PUPPETEER_CONFIG  chemin d'un fichier de configuration Puppeteer (-p)
--   PANDOC_MERMAID_DIR        dossier des images (défaut : sortie/mermaid)

local function dossier_sortie()
  return os.getenv("PANDOC_MERMAID_DIR") or "sortie/mermaid"
end

function CodeBlock(el)
  if not el.classes:includes("mermaid") then return nil end

  local ext = FORMAT:match("docx") and "png" or "svg"
  local dir = dossier_sortie()
  pandoc.system.make_directory(dir, true)
  local base = dir .. "/" .. pandoc.sha1(el.text)
  local src, out = base .. ".mmd", base .. "." .. ext

  local f = assert(io.open(src, "w")); f:write(el.text); f:close()

  -- htmlLabels: false — le texte est écrit en <text> SVG, lisible par Typst
  -- (les étiquettes HTML <foreignObject> ne sont rendues que par les navigateurs)
  local args = { "-i", src, "-o", out, "-b", "transparent", "-q", "-c", "filters/mermaid-config.json" }
  local pup = os.getenv("MERMAID_PUPPETEER_CONFIG")
  if pup and pup ~= "" then table.insert(args, "-p"); table.insert(args, pup) end

  -- Windows : mmdc est un script « mmdc.cmd » (npm) que pandoc.pipe ne sait pas lancer
  -- directement ; on passe par l'interpréteur de commandes.
  local windows = package.config:sub(1, 1) == "\\"
  local ok, err
  if windows then
    ok, err = pcall(pandoc.pipe, "cmd", { "/c", "mmdc", table.unpack(args) }, "")
  else
    ok, err = pcall(pandoc.pipe, "mmdc", args, "")
  end
  if not ok then
    io.stderr:write("[mermaid.lua] schéma non rendu (mmdc absent ou en erreur) : bloc conservé en code\n")
    io.stderr:write("[mermaid.lua] détail : " .. tostring(err):gsub("\n", " "):sub(1, 300) .. "\n")
    return nil
  end

  -- chemin relatif à la racine du projet : pandoc et Typst y sont lancés
  return pandoc.Para({ pandoc.Image({ pandoc.Str("Schéma") }, out) })
end
