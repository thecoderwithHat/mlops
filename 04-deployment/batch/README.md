# Batch Scoring

Batch scoring applies a trained model to a large dataset (e.g., all rides in a month) and writes predictions to a file.

## Files
- `score.py` — main batch scoring entrypoint
- `score_backfill.py` — example of running across historical months
- `score_deploy.py` — helper for score-time packaging and deployment
- `score.ipynb` — exploratory notebook for batch runs

## Inputs and outputs
- Input: NYC taxi parquet or CSV files for a month
- Output: A file with predictions (CSV/Parquet) and optional logs

## Running locally
1. Activate environment
```bash
pip install -r ../../02-experiment-tracking/requirements.txt
```
2. Run a single month
```bash
python score.py --year 2021 --month 1 --model-uri "models:/taxi-duration@Production"
```
If you don't use the registry, pass a `--model-path` to a local MLflow run artifact instead.

## Tips
- Validate your input schema (pickup/dropoff, distance, PULocationID/DOLocationID)
- Preprocess consistently with the same pipeline used in training
- Log run metadata (counts, timings) to help monitoring

## Troubleshooting
- If MLflow can't find artifacts, verify `MLFLOW_TRACKING_URI` and permissions
- Large files: consider chunked processing or Dask/Spark
