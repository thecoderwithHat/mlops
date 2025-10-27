# Web Service — Real-time Predictions

A minimal Flask app that serves trip duration predictions. Includes a Dockerfile for containerized deployment.

## Files
- `predict.py` — Flask app exposing `/predict`
- `preprocessor.b`, `lin_reg.bin` — example serialized preprocessor and model
- `Dockerfile` — container image definition
- `test.py` — quick smoke test
- `readme.md` — original short notes (kept for history)

## API
- Endpoint: `POST /predict`
- Input JSON example:
```json
{
  "PULocationID": 10,
  "DOLocationID": 50,
  "trip_distance": 3.1,
  "passenger_count": 1,
  "pickup_datetime": "2021-01-15 14:30:00"
}
```
- Response example:
```json
{ "duration": 780.5 }
```

## Run locally
```bash
pip install flask
python predict.py
# open http://127.0.0.1:9696
```

## Build & run with Docker
```bash
docker build -t ride-duration-prediction-service:v1 .
docker run -it --rm -p 9696:9696 ride-duration-prediction-service:v1
```

## Using MLflow models
Prefer loading from the MLflow Model Registry for traceability:
- Set `MLFLOW_TRACKING_URI`
- Configure `MODEL_NAME` and `MODEL_STAGE` (e.g., `Production`)
- Load via `mlflow.pyfunc.load_model("models:/NAME@STAGE")`

## Tips
- Keep preprocessing identical to training
- Add input validation and schema checks
- Add observability: request logs, latencies, simple metrics
