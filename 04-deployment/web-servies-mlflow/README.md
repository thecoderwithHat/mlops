# Web Service (MLflow Artifacts)

This example demonstrates serving a model using artifacts tracked locally by MLflow (SQLite + filesystem).

⚠️ Note: The folder name has a typo (`web-servies-mlflow`). Consider renaming to `web-services-mlflow` in a future cleanup PR.

## Files
- `predict.py` — example service loading local artifacts
- `mlflow.db`, `mlartifacts/` — local MLflow backend store and artifacts
- `dict_vectorizer.bin`, `lin_reg.bin` — example artifacts for quick testing
- `random-forest.ipynb` — alternative model experiment

## Running
1. Ensure dependencies are installed
```bash
pip install -r ../../02-experiment-tracking/requirements.txt
```
2. Set `MLFLOW_TRACKING_URI` if needed (e.g., `sqlite:///mlflow.db`)
3. Start the service
```bash
python predict.py
```

## When to use
- Local demos and learning exercises
- Validating an artifact layout before moving to a registry

## Tips
- For production, prefer the Model Registry (`models:/name@stage`)
- Keep environment files (conda/requirements) with the model for reproducibility
