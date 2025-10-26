# GitHub CI/CD Workflows Documentation

## 📋 Overview

This repository contains a comprehensive CI/CD pipeline for the MLOps project, implementing automated testing, model training, deployment, and monitoring workflows.

## 🔄 Workflow Files

### 1. Main CI/CD Pipeline (`ci-cd.yml`)

**Trigger**: Push to `main`/`develop` branches, Pull Requests, Manual trigger

**Jobs**:
- ✅ **Code Quality & Linting**: Black, isort, Flake8, Pylint
- 🧪 **Unit Tests**: Multi-version Python testing (3.9, 3.10, 3.11)
- 📓 **Notebook Validation**: Jupyter notebook syntax validation
- 🐳 **Docker Image Build**: Build and push to GitHub Container Registry
- 🤖 **Model Training**: Train and track ML models with MLflow
- ✓ **Model Validation**: Validate model performance metrics
- 📊 **Monitoring Setup**: Deploy and test monitoring stack
- 🔗 **Integration Tests**: End-to-end testing with PostgreSQL
- 🔒 **Security Scanning**: Trivy and pip-audit vulnerability scanning
- 🚀 **Deployment**: Deploy to staging and production environments
- 📢 **Notifications**: Alert team of pipeline status

**Environment Variables**:
```yaml
PYTHON_VERSION: '3.11'
DOCKER_REGISTRY: ghcr.io
IMAGE_NAME: ${{ github.repository }}
```

### 2. Model Training Pipeline (`train-model.yml`)

**Trigger**: Manual workflow dispatch with parameters

**Input Parameters**:
- `model_type`: Model algorithm (linear_regression, xgboost, random_forest)
- `data_month`: Training data period (YYYY-MM format)
- `experiment_name`: MLflow experiment identifier

**Features**:
- Downloads training data from NYC Taxi dataset
- Starts MLflow tracking server
- Trains model with specified configuration
- Registers model in MLflow Model Registry
- Generates model card with metadata
- Uploads artifacts for 90-day retention

**Usage**:
```bash
# Via GitHub UI: Actions → Model Training Pipeline → Run workflow
# Select parameters and click "Run workflow"
```

**Artifacts**:
- Trained model files
- MLflow artifacts and metadata
- Model card with training details

### 3. Model Monitoring Pipeline (`monitor-model.yml`)

**Trigger**: 
- Scheduled (every 6 hours)
- Manual workflow dispatch

**Input Parameters**:
- `alert_threshold`: Drift detection threshold (default: 0.5)

**Features**:
- Calculates Evidently metrics (drift, data quality)
- Stores metrics in PostgreSQL
- Detects anomalies and drift
- Creates GitHub issues for alerts
- Generates monitoring reports
- Updates Grafana dashboards

**Database Schema**:
```sql
CREATE TABLE ml_metrics (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP NOT NULL,
    prediction_drift FLOAT,
    num_drifted_columns INT,
    share_missing_values FLOAT,
    dataset_drift BOOLEAN,
    drift_score FLOAT,
    model_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Alert Conditions**:
- Drift score exceeds threshold
- Automatic GitHub issue creation
- Monitoring report uploaded as artifact

### 4. Service Deployment Pipeline (`deploy-service.yml`)

**Trigger**: Manual workflow dispatch with parameters

**Input Parameters**:
- `environment`: staging or production
- `model_version`: Model version identifier
- `service_type`: web-service, batch, or mlflow-service

**Deployment Strategy**:

**Staging**:
1. Validate model
2. Build Docker image
3. Deploy to staging environment
4. Run smoke tests
5. Report results

**Production**:
1. All staging steps
2. Create deployment backup
3. Canary deployment (10% traffic)
4. Monitor canary metrics
5. Full rollout (100% traffic)
6. Production smoke tests
7. Update model registry

**Rollback**:
- Automatic rollback on failure
- Incident issue creation
- Previous version restoration

## 🔧 Setup Instructions

### 1. Repository Secrets

Configure the following secrets in GitHub Settings → Secrets and variables → Actions:

```bash
# Required Secrets
GITHUB_TOKEN           # Automatically provided by GitHub
AWS_ACCESS_KEY_ID      # If using AWS
AWS_SECRET_ACCESS_KEY  # If using AWS
MLFLOW_TRACKING_URI    # MLflow server URL
SLACK_WEBHOOK_URL      # For notifications (optional)
```

### 2. Repository Variables

Configure variables for different environments:

```yaml
# Production
PROD_API_URL: https://api.example.com
PROD_DB_HOST: prod-db.example.com

# Staging
STAGING_API_URL: https://staging-api.example.com
STAGING_DB_HOST: staging-db.example.com
```

### 3. Branch Protection Rules

Set up branch protection for `main` branch:

1. Go to Settings → Branches → Add rule
2. Branch name pattern: `main`
3. Enable:
   - ✅ Require pull request reviews before merging
   - ✅ Require status checks to pass before merging
   - ✅ Require branches to be up to date before merging
   - ✅ Include administrators
4. Required status checks:
   - `lint`
   - `test (3.11)`
   - `validate-notebooks`
   - `security-scan`

### 4. GitHub Environments

Create environments in Settings → Environments:

**Staging Environment**:
- Name: `staging`
- Deployment protection rules: None (auto-deploy)
- Environment secrets: STAGING_* variables
- URL: https://staging-api.example.com

**Production Environment**:
- Name: `production`
- Deployment protection rules:
  - ✅ Required reviewers (at least 1)
  - ✅ Wait timer: 5 minutes
- Environment secrets: PROD_* variables
- URL: https://api.example.com

## 📊 Monitoring Dashboard Integration

### Grafana Setup

1. **Datasource Configuration**:
   - Pre-configured via `config/grafana_datasources.yaml`
   - PostgreSQL connection to metrics database

2. **Dashboard Provisioning**:
   - Place dashboard JSON files in `05-monitoring/dashboards/`
   - Auto-loaded via `config/grafana_dashboards.yaml`

3. **Metrics Collected**:
   - Prediction drift scores
   - Feature drift detection
   - Data quality metrics
   - Model performance indicators

### Alert Configuration

**GitHub Issues**:
- Automatically created when drift exceeds threshold
- Tagged with `model-monitoring`, `alert`, `drift-detection`
- Includes drift score and monitoring report link

**Custom Notifications**:
- Modify `monitor-model.yml` to add Slack/email notifications
- Example:
```bash
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"Model drift detected!"}' \
  $SLACK_WEBHOOK_URL
```

## 🚀 Usage Examples

### Trigger Model Training

**Via GitHub UI**:
1. Go to Actions tab
2. Select "Model Training Pipeline"
3. Click "Run workflow"
4. Select parameters:
   - Model type: xgboost
   - Data month: 2021-01
   - Experiment name: duration-prediction
5. Click "Run workflow"

**Via GitHub CLI**:
```bash
gh workflow run train-model.yml \
  -f model_type=xgboost \
  -f data_month=2021-01 \
  -f experiment_name=duration-prediction
```

**Via API**:
```bash
curl -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/OWNER/REPO/actions/workflows/train-model.yml/dispatches \
  -d '{"ref":"main","inputs":{"model_type":"xgboost","data_month":"2021-01"}}'
```

### Deploy Service

**Via GitHub UI**:
1. Go to Actions tab
2. Select "Deploy Model Service"
3. Click "Run workflow"
4. Select parameters:
   - Environment: staging
   - Model version: v1.2.3
   - Service type: web-service
5. Click "Run workflow"

**Via GitHub CLI**:
```bash
gh workflow run deploy-service.yml \
  -f environment=production \
  -f model_version=v1.2.3 \
  -f service_type=web-service
```

### Check Monitoring Status

**View Latest Metrics**:
```bash
# Check recent workflow runs
gh run list --workflow=monitor-model.yml --limit 5

# Download monitoring report
gh run download RUN_ID --name monitoring-report-*
```

**Query Metrics Database**:
```sql
-- Connect to PostgreSQL
psql -h localhost -U postgres -d test

-- View latest metrics
SELECT 
    timestamp,
    prediction_drift,
    drift_score,
    dataset_drift
FROM ml_metrics
WHERE timestamp > NOW() - INTERVAL '24 hours'
ORDER BY timestamp DESC;
```

## 🔍 Troubleshooting

### Common Issues

#### 1. Workflow Fails at Docker Build

**Error**: `Error: buildx failed with: ERROR: failed to solve: ...`

**Solution**:
- Check Dockerfile syntax
- Verify base image availability
- Ensure all required files are in context
- Check disk space on runner

```bash
# Test locally
docker build -t test:latest 04-deployment/web-services/
```

#### 2. Model Training Timeout

**Error**: `Error: The operation was canceled.`

**Solution**:
- Increase timeout in workflow:
```yaml
jobs:
  train:
    timeout-minutes: 120  # Increase from default 360
```
- Reduce training data size for CI/CD
- Use smaller model for testing

#### 3. Database Connection Failed

**Error**: `could not connect to server: Connection refused`

**Solution**:
- Verify service configuration:
```yaml
services:
  postgres:
    options: >-
      --health-cmd pg_isready
      --health-interval 10s
      --health-timeout 5s
      --health-retries 5
```
- Wait for service to be ready:
```bash
sleep 30  # Add delay after service start
```

#### 4. Artifact Upload Failed

**Error**: `Unable to upload artifact: Artifact size exceeds limit`

**Solution**:
- Reduce artifact size:
```bash
# Exclude large files
tar -czf models.tar.gz --exclude='*.parquet' models/
```
- Split into multiple artifacts
- Use external storage (S3, Azure Blob)

#### 5. Secret Not Found

**Error**: `Error: Secret MLFLOW_TRACKING_URI not found`

**Solution**:
- Add secret in GitHub Settings → Secrets
- Use correct secret name in workflow
- Check environment-specific secrets

### Debug Workflow

Enable debug logging:

```bash
# In repository settings → Secrets, add:
ACTIONS_RUNNER_DEBUG = true
ACTIONS_STEP_DEBUG = true
```

View detailed logs in workflow run.

## 📈 Metrics and Monitoring

### Workflow Metrics

Track the following in GitHub Actions:
- ✅ Success rate per workflow
- ⏱️ Average execution time
- 🔄 Deployment frequency
- ⚠️ Failure rate and MTTR

### Model Metrics

Automatically tracked:
- Training duration
- Model accuracy/performance
- Drift scores over time
- Data quality metrics
- Prediction latency

### Infrastructure Metrics

Monitor via Grafana:
- API response time
- Request throughput
- Error rates
- Resource utilization
- Database performance

## 🔐 Security Best Practices

### 1. Secrets Management

- ✅ Use GitHub Secrets for sensitive data
- ✅ Rotate secrets regularly
- ✅ Use environment-specific secrets
- ❌ Never commit secrets to repository
- ❌ Never log secrets in workflow output

### 2. Dependency Scanning

- Trivy for container vulnerabilities
- pip-audit for Python package vulnerabilities
- Dependabot for automatic updates

### 3. Code Scanning

```yaml
# Enable CodeQL scanning
- name: Initialize CodeQL
  uses: github/codeql-action/init@v3
  with:
    languages: python

- name: Perform CodeQL Analysis
  uses: github/codeql-action/analyze@v3
```

### 4. Image Signing

Sign Docker images:
```yaml
- name: Sign container image
  run: |
    cosign sign ${{ env.DOCKER_REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
```

## 🎯 Best Practices

### 1. Workflow Design

- ✅ Use matrix strategy for multi-version testing
- ✅ Cache dependencies to speed up builds
- ✅ Use `continue-on-error` for non-critical steps
- ✅ Implement proper error handling
- ✅ Add meaningful step names and descriptions

### 2. Model Versioning

- ✅ Use semantic versioning (v1.2.3)
- ✅ Tag models with Git SHA
- ✅ Include training data version
- ✅ Track experiment metadata

### 3. Testing Strategy

- ✅ Unit tests for individual functions
- ✅ Integration tests for end-to-end flows
- ✅ Smoke tests after deployment
- ✅ Performance/load testing for production

### 4. Deployment Strategy

- ✅ Use canary deployments for production
- ✅ Implement automatic rollback
- ✅ Require manual approval for production
- ✅ Run smoke tests after deployment

### 5. Monitoring

- ✅ Monitor model performance continuously
- ✅ Set up alerts for drift detection
- ✅ Track data quality metrics
- ✅ Log predictions for debugging

## 📚 Additional Resources

### GitHub Actions Documentation
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Events that trigger workflows](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows)
- [Environment variables](https://docs.github.com/en/actions/learn-github-actions/environment-variables)

### MLOps Resources
- [MLflow Documentation](https://mlflow.org/docs/latest/index.html)
- [Evidently AI Documentation](https://docs.evidentlyai.com/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

### Monitoring & Observability
- [Grafana Documentation](https://grafana.com/docs/)
- [Prometheus Best Practices](https://prometheus.io/docs/practices/)

## 🤝 Contributing

To add or modify workflows:

1. Create feature branch: `git checkout -b feature/new-workflow`
2. Add/modify workflow files in `.github/workflows/`
3. Test locally using [act](https://github.com/nektos/act):
   ```bash
   act -W .github/workflows/ci-cd.yml
   ```
4. Commit and push changes
5. Create pull request
6. Ensure all checks pass

## 📝 Changelog

### Version 1.0.0 (October 2025)
- ✅ Initial CI/CD pipeline setup
- ✅ Model training workflow
- ✅ Model monitoring workflow
- ✅ Service deployment workflow
- ✅ Security scanning integration
- ✅ Comprehensive documentation

---

**Last Updated**: October 26, 2025  
**Maintained By**: MLOps Team  
**Contact**: See CODEOWNERS file
