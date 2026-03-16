# IMDB Market Basket Analysis (Notebook Package)

This folder is a clean package you can upload as a GitHub repo and run directly.

## Structure

```text
github_upload/
├─ code/
│  ├─ experiment-code-v4.0.ipynb
│  └─ data/
│     └─ imdb_top_1000.csv
├─ requirements.txt
└─ .gitignore
```

## Quick Start

### 1) Create environment and install dependencies

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

### 2) Run notebook

```bash
cd code
jupyter lab
```

Open `experiment-code-v4.0.ipynb` and run cells from top to bottom.

## Data

`code/data/imdb_top_1000.csv` is included, so the notebook can run without downloading from Kaggle.

If you remove this CSV, the notebook will try to download it using `kagglehub`.
