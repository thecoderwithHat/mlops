# Tests

This folder contains unit/integration tests for selected components.

## Files
- `test_prediction_service.py` — smoke test for the prediction service
- `requirements.txt` — extra test-only requirements

## Running tests locally
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
pytest -q
```

## In CI
The GitHub Actions pipeline runs tests across multiple Python versions with coverage and style checks.

## Writing good tests
- Keep tests small and focused
- Use fixtures for common test data
- Include at least one negative test (bad input)
