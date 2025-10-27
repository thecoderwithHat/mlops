# MLflow Scenarios — Quick Practice

This folder contains three small, focused notebooks that help you build intuition for MLflow.

## Scenarios
- `scenario-1.ipynb` — Your first MLflow run (log a param, a metric, and an artifact)
- `scenario-2.ipynb` — Compare multiple runs and use tags to organize
- `scenario-3.ipynb` — Load a saved model (pyfunc) and run inference

## How to use
1. Ensure you have a Python environment with MLflow:
```bash
pip install mlflow
```
2. Launch Jupyter and open a scenario notebook:
```bash
jupyter notebook scenario-1.ipynb
```
3. (Optional) Start the MLflow UI to visualize runs:
```bash
mlflow ui --backend-store-uri sqlite:///../mlflow.db --default-artifact-root ../mlruns
```

## Learning checkpoints
- Understand the difference between parameters, metrics, and artifacts
- Learn how to organize runs with experiments and tags
- Practice loading a model and validating predictions

## Tips
- Keep runs small and focused — each scenario demonstrates one concept
- Use a consistent experiment name, e.g., `mlflow-scenarios`
