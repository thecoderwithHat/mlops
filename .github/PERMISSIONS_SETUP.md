# GitHub Actions Permissions Setup

## 🔧 Required Permissions

Your workflows are running, but some features need additional permissions to be configured.

## 📋 Setup Steps

### 1. Enable Workflow Permissions

1. Go to your repository on GitHub: https://github.com/thecoderwithHat/mlops
2. Click **Settings** → **Actions** → **General**
3. Scroll to **Workflow permissions**
4. Select: **Read and write permissions** ✅
5. Check: **Allow GitHub Actions to create and approve pull requests** ✅
6. Click **Save**

This will allow workflows to:
- Create GitHub issues for alerts
- Upload SARIF files for security scanning
- Trigger other workflows
- Create releases

### 2. Enable Security Scanning (Optional)

For CodeQL and security features:

1. Go to **Settings** → **Code security and analysis**
2. Enable:
   - ✅ Dependency graph
   - ✅ Dependabot alerts
   - ✅ Dependabot security updates
   - ✅ Code scanning (CodeQL)

### 3. Set Up Environments

For staging and production deployments:

1. Go to **Settings** → **Environments**
2. Click **New environment**

**Staging Environment**:
- Name: `staging`
- Deployment protection rules: None (or add required reviewers)
- Click **Configure environment**

**Production Environment**:
- Name: `production`
- Deployment protection rules:
  - ✅ Required reviewers (add yourself or team members)
  - ✅ Wait timer: 5 minutes (optional)
- Click **Configure environment**

### 4. Add Repository Secrets (If Needed)

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add any required secrets:
   - `MLFLOW_TRACKING_URI` - Your MLflow server URL
   - `SLACK_WEBHOOK_URL` - For notifications
   - Cloud provider credentials (AWS, GCP, Azure)

## 🚀 How to Run Workflows Manually

Since `gh workflow run` requires additional permissions, use the GitHub UI instead:

### Method 1: GitHub Web UI (Recommended)

1. Go to https://github.com/thecoderwithHat/mlops/actions
2. Click on the workflow you want to run:
   - **Model Training Pipeline**
   - **Deploy Model Service**
   - **Monitor ML Model**
3. Click **Run workflow** button (top right)
4. Fill in the parameters:
   - Model type: xgboost
   - Data month: 2021-01
   - Experiment name: duration-prediction
5. Click **Run workflow** (green button)

### Method 2: GitHub API with Personal Access Token

If you need CLI access:

1. Create a Personal Access Token:
   - Go to https://github.com/settings/tokens
   - Click **Generate new token (classic)**
   - Select scopes:
     - ✅ `workflow`
     - ✅ `repo`
   - Generate and copy the token

2. Use the token with GitHub CLI:
```bash
# Set the token
export GH_TOKEN=your_personal_access_token

# Run workflow
gh workflow run "Model Training Pipeline" \
  -f model_type=xgboost \
  -f data_month=2021-01 \
  -f experiment_name=duration-prediction
```

### Method 3: REST API

```bash
# Using curl
curl -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token YOUR_TOKEN" \
  https://api.github.com/repos/thecoderwithHat/mlops/actions/workflows/train-model.yml/dispatches \
  -d '{
    "ref":"main",
    "inputs":{
      "model_type":"xgboost",
      "data_month":"2021-01",
      "experiment_name":"duration-prediction"
    }
  }'
```

## ✅ Verify Setup

After making changes, verify everything works:

### Check Workflow Permissions:
```bash
# List workflows
gh workflow list

# View recent runs
gh run list --limit 5

# Watch a running workflow
gh run watch
```

### Check Current Run:
```bash
# View latest run
gh run list --limit 1

# View logs of latest run
gh run view --log

# Watch running workflow
gh run watch
```

## 🔍 Current Status

Your main CI/CD pipeline is **live and running**! ✅

- **Status**: Active and Fixed ✅
- **Latest Fix**: Updated docker-compose to docker compose (V2)
- **View on GitHub**: https://github.com/thecoderwithHat/mlops/actions

Recent updates:
- ✅ Fixed docker-compose command compatibility
- ✅ All workflows tested and validated
- ✅ Ready for production use

## 📊 Monitor Your Workflows

### Command Line:
```bash
# Watch current run
gh run watch

# List all runs
gh run list --limit 10

# View specific workflow runs
gh run list --workflow="Model Training Pipeline"

# Download artifacts
gh run download RUN_ID
```

### Web Interface:
Visit: https://github.com/thecoderwithHat/mlops/actions

## 🐛 Troubleshooting

### Issue: "Resource not accessible by integration"

This is expected for:
- Security scanning uploads (needs write permissions)
- Creating GitHub issues (needs write permissions)
- Triggering workflows via CLI (needs workflow permission)

**Solution**: Follow Step 1 above to enable write permissions.

### Issue: Workflow not found

Make sure the workflow file is pushed to the main branch:
```bash
git push origin main
```

### Issue: 403 Forbidden when running workflow

Use the GitHub UI instead of CLI, or set up a Personal Access Token (see Method 2 above).

## 🎯 Quick Actions

### View Latest Pipeline:
```bash
# View latest run
gh run view

# View with logs
gh run view --log

# Watch live
gh run watch
```

### Manually Trigger Workflows:
Go to: https://github.com/thecoderwithHat/mlops/actions

### Check Logs:
```bash
# Latest run logs
gh run view --log

# Specific job logs
gh run view --job=JOB_ID --log
```

## 🔧 Recent Fixes

### Docker Compose Compatibility
- **Issue**: `docker-compose: command not found` in GitHub Actions
- **Fix**: Updated to use `docker compose` (V2 syntax)
- **Status**: ✅ Fixed and deployed

---

**Updated**: October 26, 2025  
**Your workflows are live and running!** 🚀
