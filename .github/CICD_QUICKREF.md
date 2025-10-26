# CI/CD Quick Reference Guide

## 🚀 Quick Commands

### Run Workflows Manually

```bash
# Train a model
gh workflow run train-model.yml \
  -f model_type=xgboost \
  -f data_month=2021-01 \
  -f experiment_name=duration-prediction

# Deploy to staging
gh workflow run deploy-service.yml \
  -f environment=staging \
  -f model_version=v1.0.0 \
  -f service_type=web-service

# Deploy to production
gh workflow run deploy-service.yml \
  -f environment=production \
  -f model_version=v1.0.0 \
  -f service_type=web-service

# Run monitoring
gh workflow run monitor-model.yml \
  -f alert_threshold=0.5
```

### Check Workflow Status

```bash
# List recent runs
gh run list --limit 10

# View specific workflow runs
gh run list --workflow=ci-cd.yml --limit 5

# Watch a running workflow
gh run watch

# View run details
gh run view RUN_ID

# Download artifacts
gh run download RUN_ID
```

### Manage Secrets

```bash
# Add secret
gh secret set MLFLOW_TRACKING_URI

# List secrets
gh secret list

# Delete secret
gh secret delete SECRET_NAME
```

## 🔄 Workflow Triggers

| Workflow | Automatic Trigger | Manual Trigger | Parameters |
|----------|------------------|----------------|------------|
| CI/CD Pipeline | Push to main/develop, PR | ✅ | None |
| Model Training | None | ✅ | model_type, data_month, experiment_name |
| Model Monitoring | Every 6 hours (cron) | ✅ | alert_threshold |
| Service Deployment | None | ✅ | environment, model_version, service_type |

## 📊 Key Metrics to Monitor

### Pipeline Health
- ✅ Success rate: Target >95%
- ⏱️ Build time: Target <15 minutes
- 🔄 Deployment frequency: Target >1 per day
- ⚡ Lead time: Target <1 hour

### Model Performance
- 🎯 Model accuracy: Monitor trend
- 📉 Drift score: Alert if >0.5
- 🔍 Data quality: Alert if missing >10%
- ⏲️ Prediction latency: Target <100ms

## 🔧 Common Tasks

### 1. Add a New Test

```python
# tests/test_model.py
import pytest
from src.model import predict

def test_prediction():
    """Test model prediction"""
    input_data = {
        "PULocationID": 10,
        "DOLocationID": 50,
        "trip_distance": 40
    }
    result = predict(input_data)
    assert result > 0
    assert isinstance(result, float)
```

### 2. Update Docker Image

```dockerfile
# 04-deployment/web-services/Dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 9696

CMD ["gunicorn", "--bind", "0.0.0.0:9696", "predict:app"]
```

### 3. Add Monitoring Alert

```yaml
# In monitor-model.yml
- name: Check thresholds
  run: |
    if [ $DRIFT_SCORE > 0.7 ]; then
      echo "CRITICAL: High drift detected"
      exit 1
    fi
```

### 4. Configure Branch Protection

```bash
# Via GitHub CLI
gh api repos/:owner/:repo/branches/main/protection \
  -X PUT \
  -f required_status_checks[strict]=true \
  -f required_status_checks[contexts][]=lint \
  -f required_status_checks[contexts][]=test
```

## 🐛 Debugging Tips

### Enable Debug Logging

```yaml
# Add to workflow step
- name: Debug step
  run: |
    echo "::debug::Debug message"
    echo "::warning::Warning message"
    echo "::error::Error message"
```

### Test Locally with Act

```bash
# Install act
brew install act  # macOS
# or
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Run workflow locally
act -W .github/workflows/ci-cd.yml

# Run specific job
act -j test

# Use specific event
act push
```

### Check Workflow Syntax

```bash
# Validate workflow file
gh workflow view ci-cd.yml

# Or use online validator
# https://rhysd.github.io/actionlint/
```

## 📋 Checklist: New Feature Deployment

- [ ] 1. Create feature branch
- [ ] 2. Write code and tests
- [ ] 3. Run tests locally
- [ ] 4. Commit and push
- [ ] 5. Create pull request
- [ ] 6. Wait for CI checks ✅
- [ ] 7. Request code review
- [ ] 8. Merge to main
- [ ] 9. Train new model (if needed)
- [ ] 10. Deploy to staging
- [ ] 11. Run smoke tests
- [ ] 12. Deploy to production
- [ ] 13. Monitor metrics
- [ ] 14. Update documentation

## 🎯 Performance Optimization

### Speed Up Builds

```yaml
# Cache dependencies
- uses: actions/cache@v3
  with:
    path: ~/.cache/pip
    key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}

# Use matrix strategy efficiently
strategy:
  fail-fast: false  # Continue other jobs if one fails
  matrix:
    python-version: ['3.11']  # Reduce to only necessary versions
```

### Optimize Docker Builds

```dockerfile
# Multi-stage build
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

FROM python:3.11-slim
COPY --from=builder /root/.local /root/.local
COPY . .
ENV PATH=/root/.local/bin:$PATH
CMD ["python", "app.py"]
```

### Use Build Cache

```yaml
- name: Build with cache
  uses: docker/build-push-action@v5
  with:
    cache-from: type=gha
    cache-to: type=gha,mode=max
```

## 🔒 Security Checklist

- [ ] Secrets stored in GitHub Secrets
- [ ] No hardcoded credentials
- [ ] Dependabot enabled
- [ ] Security scanning enabled
- [ ] Branch protection rules active
- [ ] Required reviews configured
- [ ] Signed commits enforced
- [ ] Container scanning enabled
- [ ] HTTPS/TLS for all endpoints
- [ ] Environment-specific secrets

## 📞 Support & Resources

### Getting Help
- 📖 Check this documentation first
- 🐛 Check workflow logs in GitHub Actions
- 💬 Ask in team Slack channel
- 🎫 Create GitHub issue for bugs
- 📧 Contact DevOps team

### Useful Links
- [Repository](https://github.com/thecoderwithHat/mlops)
- [Actions Tab](https://github.com/thecoderwithHat/mlops/actions)
- [Grafana Dashboard](http://localhost:3000)
- [MLflow UI](http://localhost:5000)
- [API Documentation](https://api.example.com/docs)

---

**Quick Tip**: Bookmark this page and the [main workflows README](.github/workflows/README.md) for easy reference!
