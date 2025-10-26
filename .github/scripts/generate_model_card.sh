#!/bin/bash
# Generate a model card for the trained model

set -e

MODEL_TYPE="${1:-unknown}"
DATA_MONTH="${2:-unknown}"
EXPERIMENT_NAME="${3:-unknown}"
GITHUB_RUN_NUMBER="${4:-0}"
GITHUB_SHA="${5:-unknown}"
GITHUB_REPOSITORY="${6:-unknown}"
GITHUB_SERVER_URL="${7:-https://github.com}"
GITHUB_RUN_ID="${8:-0}"
MLFLOW_URI="${9:-http://localhost:5000}"

# Get run ID if available
RUN_ID="N/A"
if [ -f "03-orchestration/run_id.txt" ]; then
  RUN_ID=$(cat 03-orchestration/run_id.txt)
fi

# Generate model card
cat > model_card.md << 'MODELCARD'
# Model Card: MODEL_TYPE_PLACEHOLDER

## Model Details
- **Model Type**: MODEL_TYPE_PLACEHOLDER
- **Training Data**: NYC Taxi DATA_MONTH_PLACEHOLDER
- **Experiment**: EXPERIMENT_NAME_PLACEHOLDER
- **Training Date**: TRAINING_DATE_PLACEHOLDER
- **GitHub Run**: GITHUB_RUN_NUMBER_PLACEHOLDER
- **Commit**: GITHUB_SHA_PLACEHOLDER
- **MLflow Run ID**: RUN_ID_PLACEHOLDER

## Training Configuration
- Python Version: 3.11
- MLflow Tracking URI: MLFLOW_URI_PLACEHOLDER
- Artifact Root: Local filesystem

## Model Performance
Check MLflow UI for detailed metrics:
- RMSE (validation)
- Training time
- Model parameters

## Artifacts
- Model files: Available in GitHub Actions artifacts
- MLflow artifacts: Check mlartifacts/ directory
- Preprocessor: models/preprocessor.b

## Usage
Download the artifacts and load the model with MLflow.

## Training Workflow
- Repository: GITHUB_REPOSITORY_PLACEHOLDER
- Workflow: Model Training Pipeline
- Run URL: GITHUB_SERVER_URL_PLACEHOLDER/GITHUB_REPOSITORY_PLACEHOLDER/actions/runs/GITHUB_RUN_ID_PLACEHOLDER
MODELCARD

# Replace placeholders
sed -i "s|MODEL_TYPE_PLACEHOLDER|$MODEL_TYPE|g" model_card.md
sed -i "s|DATA_MONTH_PLACEHOLDER|$DATA_MONTH|g" model_card.md
sed -i "s|EXPERIMENT_NAME_PLACEHOLDER|$EXPERIMENT_NAME|g" model_card.md
sed -i "s|TRAINING_DATE_PLACEHOLDER|$(date -u +"%Y-%m-%d %H:%M:%S UTC")|g" model_card.md
sed -i "s|GITHUB_RUN_NUMBER_PLACEHOLDER|$GITHUB_RUN_NUMBER|g" model_card.md
sed -i "s|GITHUB_SHA_PLACEHOLDER|$GITHUB_SHA|g" model_card.md
sed -i "s|RUN_ID_PLACEHOLDER|$RUN_ID|g" model_card.md
sed -i "s|MLFLOW_URI_PLACEHOLDER|$MLFLOW_URI|g" model_card.md
sed -i "s|GITHUB_REPOSITORY_PLACEHOLDER|$GITHUB_REPOSITORY|g" model_card.md
sed -i "s|GITHUB_SERVER_URL_PLACEHOLDER|$GITHUB_SERVER_URL|g" model_card.md
sed -i "s|GITHUB_RUN_ID_PLACEHOLDER|$GITHUB_RUN_ID|g" model_card.md

echo "✅ Model card generated"
cat model_card.md
