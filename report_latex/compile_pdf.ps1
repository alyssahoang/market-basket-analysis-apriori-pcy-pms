$ErrorActionPreference = "Stop"

# Compile main.tex to output.pdf with latexmk if available.
# Usage (PowerShell):
#   Set-ExecutionPolicy -Scope Process Bypass
#   .\compile_pdf.ps1

$main = "main.tex"

if (-not (Test-Path $main)) {
    throw "Cannot find $main in current directory: $(Get-Location)"
}

$latexmk = Get-Command latexmk -ErrorAction SilentlyContinue
$pdflatex = Get-Command pdflatex -ErrorAction SilentlyContinue
$biber = Get-Command biber -ErrorAction SilentlyContinue

# Fallback: common MiKTeX user install path (when PATH is not yet updated)
$miktexBin = Join-Path $env:LOCALAPPDATA "Programs\MiKTeX\miktex\bin\x64"
$latexmkExe = Join-Path $miktexBin "latexmk.exe"
$pdflatexExe = Join-Path $miktexBin "pdflatex.exe"
$biberExe = Join-Path $miktexBin "biber.exe"

if ($latexmk -or (Test-Path $latexmkExe)) {
    Write-Host "Using latexmk..."
    if ($latexmk) {
        latexmk -pdf -interaction=nonstopmode -file-line-error $main
    } else {
        & $latexmkExe -pdf -interaction=nonstopmode -file-line-error $main
    }
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "latexmk failed (often MiKTeX script-engine issue). Falling back to pdflatex+biber passes..."
    } else {
        Write-Host "Done. PDF: output.pdf or main.pdf (depends on latexmk config)."
        exit 0
    }
}

if ($pdflatex -or (Test-Path $pdflatexExe)) {
    Write-Host "Using pdflatex+biber passes..."

    $firstPassOutput = $null
    if ($pdflatex) {
        $firstPassOutput = pdflatex -interaction=nonstopmode -file-line-error $main 2>&1
    } else {
        $firstPassOutput = & $pdflatexExe -interaction=nonstopmode -file-line-error $main 2>&1
    }
    if ($firstPassOutput) {
        $firstPassOutput | Out-Host
    }
    if ($LASTEXITCODE -ne 0) {
        if (($firstPassOutput | Out-String) -match "fresh TeX installation") {
            throw @"
MiKTeX is installed but not fully initialized yet.
Open MiKTeX Console once, complete first-time setup, update packages, then rerun this script.
"@
        }
        throw "First pdflatex pass failed."
    }

    if ($biber) {
        biber main | Out-Null
        if ($LASTEXITCODE -ne 0) {
            throw "biber failed. Complete MiKTeX first-time setup in MiKTeX Console, then rerun."
        }
    } elseif (Test-Path $biberExe) {
        & $biberExe main | Out-Null
        if ($LASTEXITCODE -ne 0) {
            throw "biber failed. Complete MiKTeX first-time setup in MiKTeX Console, then rerun."
        }
    } else {
        throw "biber not found. Install/enable biber (MiKTeX) to build bibliography."
    }

    if ($pdflatex) {
        pdflatex -interaction=nonstopmode -file-line-error $main | Out-Null
    } else {
        & $pdflatexExe -interaction=nonstopmode -file-line-error $main | Out-Null
    }
    if ($LASTEXITCODE -ne 0) {
        throw "Second pdflatex pass failed."
    }

    if ($pdflatex) {
        pdflatex -interaction=nonstopmode -file-line-error $main | Out-Null
    } else {
        & $pdflatexExe -interaction=nonstopmode -file-line-error $main | Out-Null
    }
    if ($LASTEXITCODE -ne 0) {
        throw "Third pdflatex pass failed."
    }

    Write-Host "Done. PDF: main.pdf"
    exit 0
}

Write-Error @"
No LaTeX compiler found on this machine.
Install one of these:
1) TeX Live (includes pdflatex/latexmk), or
2) MiKTeX (+ latexmk), or
3) Use Overleaf.
"@
exit 1

