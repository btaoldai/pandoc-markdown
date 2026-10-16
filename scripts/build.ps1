<#
.SYNOPSIS
  scripts/build.ps1 — Markdown → PDF | DOCX | HTML avec les réglages de defaults/
.EXAMPLE
  .\scripts\build.ps1 exemples\demo.md pdf
.EXAMPLE
  .\scripts\build.ps1 exemples\demo.md        # les trois formats
.NOTES
  Sortie : <dossier du fichier>\sortie\<nom>.<ext> (ex. exemples\demo.md → exemples\sortie\demo.pdf).
  Prérequis : pandoc >= 3.1.2, typst (PDF), mmdc (schémas, facultatif).
#>
param(
  [Parameter(Mandatory = $true)][string]$Entree,
  [ValidateSet("pdf", "docx", "html", "all")][string]$Format = "all"
)
$ErrorActionPreference = "Stop"
# Messages des filtres (pandoc écrit en UTF-8) lisibles dans la console PowerShell 5.1
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
$racine = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $racine

$nom = [System.IO.Path]::GetFileNameWithoutExtension($Entree)
$dossier = Join-Path (Split-Path -Parent $Entree) "sortie"
New-Item -ItemType Directory -Force -Path $dossier | Out-Null
# Les schémas Mermaid rendus vont à côté des sorties (lu par filters/mermaid.lua) ; chemin en / pour pandoc
$env:PANDOC_MERMAID_DIR = (Join-Path $dossier "mermaid") -replace "\\", "/"
# Polices de la charte (Roboto, Roboto Mono) livrées avec le projet, lues par Typst
$env:TYPST_FONT_PATHS = Join-Path $racine "templates\fonts"

function Construire([string]$fmt) {
  $cible = Join-Path $dossier "$nom.$fmt"
  Write-Host "[build] $cible"
  & pandoc -d "defaults/$fmt.yaml" $Entree -o $cible
  if ($LASTEXITCODE -ne 0) { throw "pandoc a échoué pour $fmt" }
}

switch ($Format) {
  "all" { Construire "pdf"; Construire "docx"; Construire "html" }
  default { Construire $Format }
}
Get-ChildItem (Join-Path $dossier "$nom.*") | ForEach-Object { Write-Host "[build] $($_.Name)  $($_.Length) octets" }
