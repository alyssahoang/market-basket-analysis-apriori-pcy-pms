# Association Rule Mining on IMDB Top-1000 Movies

This repository contains my Master-level project in data mining, focused on frequent itemset mining and association rule analysis on movie data.

## Project Overview

The project studies how three classical algorithms behave in practice on a real transactional dataset derived from IMDB Top-1000:

- Apriori
- PCY (Park-Chen-Yu)
- PCY-Multistage (PMS)

Each movie is modeled as a basket in two settings:

- Actor-only baskets: cast members as items
- Enriched baskets: cast members + discretized movie attributes (gross, rating, votes, runtime, metascore tiers)

## Objectives

- Build a reproducible end-to-end pipeline from data cleaning to rule extraction
- Compare candidate generation and runtime across Apriori, PCY, and PMS
- Evaluate rules using support, confidence, lift, interest (leverage), Kulczynski, and Fisher's exact test
- Report statistically supported and interpretable associations

## Key Findings

- PCY and PMS preserve frequent itemsets while reducing pair-candidate counting compared with Apriori.
- On actor-only baskets at low support, hashing-based methods achieve very large runtime improvements versus Apriori.
- On enriched baskets, PMS shows stronger pruning at low support, while runtime gaps narrow at higher support thresholds.
- Final rule sets are compact and interpretable after significance and redundancy filtering.

## Repository Structure

```text
github_upload/
├─ code/
│  ├─ experiment-code-v4.0.ipynb
│  └─ data/
│     └─ imdb_top_1000.csv
├─ report.pdf
├─ report_latex/
│  ├─ main.tex
│  ├─ Market Basket Report.bib
│  ├─ compile_pdf.ps1
│  ├─ main.pdf
│  └─ figures/
├─ requirements.txt
└─ .gitignore
```

## How to Run

### 1. Create environment and install dependencies

```bash
python -m venv .venv
```

Windows PowerShell:

```powershell
.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

macOS/Linux:

```bash
source .venv/bin/activate
pip install -r requirements.txt
```

### 2. Launch notebook

```bash
cd code
jupyter lab
```

Open `experiment-code-v4.0.ipynb` and run all cells from top to bottom.

## Report

- Final report PDF: `report.pdf`
- Full LaTeX source: `report_latex/`

Rebuild PDF (Windows PowerShell):

```powershell
cd report_latex
Set-ExecutionPolicy -Scope Process Bypass
.\compile_pdf.ps1
```

If `latexmk` is unavailable, the script falls back to `pdflatex + biber + pdflatex + pdflatex`.

## Reproducibility Notes

- Dataset file `code/data/imdb_top_1000.csv` is included for local execution.
- Main experimental notebook: `code/experiment-code-v4.0.ipynb`.
- Core settings (seed, minsup grids, bucket count) are fixed and documented in notebook/report.

## Author

Tram Anh Hoang  
MSc Student, Data Science for Economics  
Universita degli Studi di Milano
