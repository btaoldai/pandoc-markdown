<#
.SYNOPSIS
  scripts/build.ps1 — Markdown → PDF | DOCX | HTML avec les réglages de defaults/
.EXAMPLE
  .\scripts\build.ps1 exemples\demo.md pdf
.EXAMPLE
  .\scripts\build.ps1 exemples\demo.md        # les trois formats
.NOTES
  Sortie : sortie\<nom>.<ext>. Prérequis : pandoc >= 3.1.2, typst (PDF), mmdc (schémas, facultatif).
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
New-Item -ItemType Directory -Force -Path "sortie" | Out-Null

function Construire([string]$fmt) {
  Write-Host "[build] $nom.$fmt"
  & pandoc -d "defaults/$fmt.yaml" $Entree -o "sortie/$nom.$fmt"
  if ($LASTEXITCODE -ne 0) { throw "pandoc a échoué pour $fmt" }
}

switch ($Format) {
  "all" { Construire "pdf"; Construire "docx"; Construire "html" }
  default { Construire $Format }
}
Get-ChildItem "sortie/$nom.*" | ForEach-Object { Write-Host "[build] $($_.Name)  $($_.Length) octets" }
