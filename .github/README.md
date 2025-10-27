# GitHub Automation

This folder contains documentation and assets for CI/CD and workflow automation.

## Workflows (`.github/workflows`)
- `ci-cd.yml` — Main pipeline: linting, tests (3.9–3.11), security scans, Docker build/push
- `train-model.yml` — Manual model training + MLflow registration + artifact upload
- `monitor-model.yml` — Scheduled Evidently monitoring, issue creation on alerts
- `deploy-service.yml` — Canary deployment flow for the web service

See `workflows/README.md` for detailed job breakdown and triggers.

## Scripts (`.github/scripts`)
- `register_model.py` — Register a trained model in MLflow Model Registry
- `generate_model_card.sh` — Produce a Markdown model card with run metadata

## Permissions and setup
- `PERMISSIONS_SETUP.md` — explains required GitHub permissions for dispatching workflows (PAT)
- `SETUP_COMPLETE.md` — summary of the configured pipeline
- `CICD_QUICKREF.md` — quick commands and common tasks
