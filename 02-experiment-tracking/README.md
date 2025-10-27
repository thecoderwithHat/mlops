# Experiment Tracking with MLflow

This module contains notebooks and assets for exploring the NYC Green Taxi dataset and tracking model experiments with MLflow.

## What you'll learn here
- Why experiment tracking matters and how MLflow helps
- How to structure a notebook to log parameters, metrics, and artifacts
- How to compare runs and choose a candidate model for orchestration

## Contents
- `duration-prediction.ipynb` — end-to-end notebook for feature engineering and model training
- `model-registry.ipynb` — demonstrates registering a model in MLflow
- `requirements.txt` — minimal packages to run the notebooks
- `data/` — sample CSV inputs (Jan/Feb 2021)
- `models/` — local artifacts (e.g., preprocessor)
- `mlruns/`, `mlflow.db` — local MLflow tracking backend (SQLite) and artifacts
- `running-mlflow-example/` — small scenarios to get comfortable with MLflow basics

## MLflow 101

MLflow tracks four key things:
- Parameters — model hyperparameters (e.g., max_depth)
- Metrics — evaluation results (e.g., RMSE)
- Artifacts — files produced (models, plots)
- Run info — who/when/where, tags, lifecycle

In notebooks, you typically:
1. `mlflow.set_tracking_uri("sqlite:///mlflow.db")` (or use the default)
2. `mlflow.set_experiment("taxi-duration")`
3. Wrap training in `with mlflow.start_run():` and log params/metrics/artifacts

## How to run locally

1. Create a virtual environment and install requirements:
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

2. Open the notebook:
```bash
jupyter notebook duration-prediction.ipynb
```

3. Start MLflow UI (optional):
```bash
mlflow ui --backend-store-uri sqlite:///mlflow.db --default-artifact-root ./mlruns
```
Open http://127.0.0.1:5000

## Choosing a model to promote
After you iterate on features and hyperparameters, sort runs by RMSE in MLflow and note the `run_id`. The orchestration step will re-use this logic to pick the best run automatically during CI/CD.

## Common pitfalls
- Logging large artifacts to Git LFS by mistake — keep them in MLflow
- Mismatch between data used in training vs. evaluation — keep a fixed reference split
- Not pinning package versions — make runs reproducible via `requirements.txt` or conda envs

## Next steps
- Move from notebooks to the scripted pipeline in `03-orchestration`
- Integrate your favorite model (e.g., XGBoost vs. Linear) and compare runs
- Register your best model in MLflow for deployment
