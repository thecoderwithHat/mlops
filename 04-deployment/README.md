# Deployment Overview

This module shows two primary deployment patterns for the NYC Taxi duration model:

- Batch scoring — process a whole month of rides and write predictions to disk
- Real-time API — serve predictions via a Flask web service (Dockerized)

## Structure
- `batch/` — batch inference scripts and notebooks
- `web-services/` — Flask service + Dockerfile
- `web-servies-mlflow/` — example of using local MLflow artifacts for serving

## Choosing a pattern
- Use batch when you have large, periodic jobs (e.g., daily backfill)
- Use real-time when latency matters and you need an always-on API

## Promotion flow
1. Train and track models (MLflow)
2. Register the best model (Model Registry)
3. Deploy: batch job or service reads from registry/artifacts
4. Monitor drift and performance, iterate

See each subfolder README for details, run instructions, and troubleshooting.
