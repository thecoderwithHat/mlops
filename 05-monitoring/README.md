# ML Model Monitoring with Evidently, PostgreSQL, and Grafana

## 📋 Overview

This directory contains a complete MLOps monitoring solution for tracking machine learning model performance in production. The stack uses:
- **Evidently**: For ML model monitoring and data drift detection
- **PostgreSQL**: As the metrics storage backend
- **Grafana**: For visualization and alerting dashboards
- **Adminer**: For database administration

## 🏗️ Architecture

```
┌─────────────────┐
│   ML Model      │
│   Predictions   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Evidently     │ ◄── Calculates metrics (drift, performance, etc.)
│   Metrics       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   PostgreSQL    │ ◄── Stores time-series metrics
│   Database      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│    Grafana      │ ◄── Visualizes metrics and alerts
│   Dashboards    │
└─────────────────┘
```

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Python 3.8+ (for running metric calculation scripts)
- Basic understanding of ML model monitoring concepts

### 1. Start the Services

```bash
cd /workspaces/mlops/05-monitoring

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### 2. Access the Services

When running in a **local environment**:
- **Grafana**: http://localhost:3000 (default credentials: admin/admin)
- **Adminer**: http://localhost:8080 (database GUI)
- **PostgreSQL**: localhost:5432

When running in a **dev container** (like GitHub Codespaces or VS Code Remote):
- VS Code will automatically forward ports
- Click on the "Ports" tab in VS Code
- Click on the port number (3000, 8080, 5432) to open in browser
- Or use the forwarded URL provided by VS Code

### 3. Initial Setup

#### Configure PostgreSQL Database
1. Access Adminer at http://localhost:8080
2. Login with:
   - **System**: PostgreSQL
   - **Server**: db
   - **Username**: postgres
   - **Password**: example
   - **Database**: test
3. Create your metrics tables (see Database Schema section)

#### Access Grafana
1. Open Grafana at http://localhost:3000
2. Default login: `admin` / `admin`
3. You'll be prompted to change the password
4. The PostgreSQL datasource is pre-configured via provisioning

## 📁 Project Structure

```
05-monitoring/
├── config/
│   ├── grafana_datasources.yaml     # Grafana datasource configuration
│   └── grafana_dashboards.yaml      # Grafana dashboard provisioning
├── dashboards/                      # Grafana dashboard JSON files
├── data/                           # Input data for monitoring
├── models/                         # Trained ML models
├── workspace/                      # Working directory for outputs
├── docker-compose.yml              # Service orchestration
├── requirements.txt                # Python dependencies
├── dummy_metrics_calculation.py    # Example metrics generation
├── evidently_metrics_calculation.py # Real Evidently metrics
├── baseline_model_nyc_taxi_data.ipynb  # Model training notebook
└── debugging_nyc_taxi_data.ipynb   # Debugging and testing
```

## 🔧 Configuration Files

### docker-compose.yml

Defines three services:

**PostgreSQL (db)**
- Port: 5432
- Password: example (change in production!)
- Network: back-tier

**Adminer**
- Port: 8080
- Database management UI
- Networks: back-tier, front-tier

**Grafana**
- Port: 3000
- Auto-provisions datasources and dashboards
- Mounts:
  - `config/grafana_datasources.yaml` → PostgreSQL connection
  - `config/grafana_dashboards.yaml` → Dashboard provider config
  - `dashboards/` → Dashboard JSON files
- Networks: back-tier, front-tier

### config/grafana_datasources.yaml

Pre-configures PostgreSQL as a Grafana datasource:
```yaml
datasources:
  - name: PostgreSQL
    type: postgres
    url: db:5432
    database: test
    user: postgres
    password: example
```

### config/grafana_dashboards.yaml

Configures Grafana to auto-load dashboards from `/opt/grafana/dashboards`:
```yaml
providers:
  - name: 'Evidently Dashboards'
    type: file
    path: /opt/grafana/dashboards
    foldersFromFilesStructure: true
```

## 📊 Database Schema

Typical Evidently metrics table structure:

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

CREATE INDEX idx_timestamp ON ml_metrics(timestamp);
CREATE INDEX idx_model_name ON ml_metrics(model_name);
```

## 🐍 Python Scripts

### Requirements

Install dependencies:
```bash
pip install -r requirements.txt
```

Key packages:
- `evidently`: ML monitoring and drift detection
- `psycopg2-binary`: PostgreSQL adapter
- `pandas`, `numpy`: Data manipulation
- `scikit-learn`, `xgboost`: ML models

### dummy_metrics_calculation.py

Generates sample metrics for testing the monitoring pipeline:
```bash
python dummy_metrics_calculation.py
```

Use this to:
- Test database connectivity
- Verify Grafana dashboards
- Simulate production metrics

### evidently_metrics_calculation.py

Calculates real ML metrics using Evidently:
```bash
python evidently_metrics_calculation.py
```

Features:
- Data drift detection
- Model performance monitoring
- Column-level drift analysis
- Target drift tracking

## 📈 Creating Grafana Dashboards

### Method 1: UI Creation

1. Go to Grafana → Dashboards → New → New Dashboard
2. Add Panel → Select PostgreSQL datasource
3. Write SQL query:
```sql
SELECT
  timestamp as time,
  prediction_drift,
  drift_score
FROM ml_metrics
WHERE $__timeFilter(timestamp)
ORDER BY timestamp
```
4. Configure visualization (Graph, Stat, Table, etc.)
5. Save dashboard → Export as JSON → Place in `dashboards/` folder

### Method 2: Provisioning

1. Create dashboard JSON in `dashboards/` folder
2. Grafana auto-loads it on startup (configured via `grafana_dashboards.yaml`)
3. Changes require container restart to reload

### Example Dashboard Panels

**Data Drift Over Time**
```sql
SELECT
  timestamp as time,
  prediction_drift as "Prediction Drift",
  dataset_drift::int as "Dataset Drift"
FROM ml_metrics
WHERE $__timeFilter(timestamp)
ORDER BY timestamp
```

**Drifted Columns Count**
```sql
SELECT
  timestamp as time,
  num_drifted_columns as "Drifted Columns"
FROM ml_metrics
WHERE $__timeFilter(timestamp)
ORDER BY timestamp
```

**Missing Values Rate**
```sql
SELECT
  timestamp as time,
  share_missing_values * 100 as "Missing %"
FROM ml_metrics
WHERE $__timeFilter(timestamp)
ORDER BY timestamp
```

## 🔍 Monitoring Workflow

### 1. Train Baseline Model
```bash
jupyter notebook baseline_model_nyc_taxi_data.ipynb
```
- Train model on historical data
- Save model artifacts to `models/`
- Calculate baseline statistics

### 2. Calculate Metrics
```bash
python evidently_metrics_calculation.py
```
- Load new production data
- Compare against baseline
- Calculate drift and performance metrics
- Store results in PostgreSQL

### 3. Visualize in Grafana
- Open Grafana dashboard
- Monitor trends over time
- Set up alerts for critical thresholds
- Investigate anomalies

### 4. Debug Issues
```bash
jupyter notebook debugging_nyc_taxi_data.ipynb
```
- Deep dive into specific time periods
- Analyze feature distributions
- Compare prediction vs actual
- Root cause analysis

## 🚨 Common Issues and Solutions

### Issue: Grafana fails to start with "is a directory" error

**Error Message:**
```
Error: could not parse provisioning config file: dashboards.yaml error: 
read /etc/grafana/provisioning/dashboards/dashboards.yaml: is a directory
```

**Solution:**
```bash
# Remove incorrect directory
rm -rf config/grafana_dashboards.yaml

# Recreate as a proper file
cat > config/grafana_dashboards.yaml << 'EOF'
apiVersion: 1
providers:
  - name: 'Evidently Dashboards'
    type: file
    path: /opt/grafana/dashboards
    foldersFromFilesStructure: true
EOF

# Restart services
docker-compose down
docker-compose up -d
```

### Issue: Cannot access localhost:8080 in dev container

**Solution:**
- Click on "Ports" tab in VS Code
- Find port 8080 (or 3000 for Grafana)
- Click "Open in Browser" or use the forwarded URL
- Alternatively, make ports public if needed

### Issue: PostgreSQL connection refused

**Symptoms:**
- Can't connect from Python scripts
- Adminer shows connection error

**Solution:**
```bash
# Check if container is running
docker-compose ps

# Check logs
docker-compose logs db

# Restart services
docker-compose restart db

# Verify network connectivity
docker-compose exec grafana ping db
```

### Issue: Grafana dashboard shows "No Data"

**Troubleshooting:**
1. Verify data exists in PostgreSQL:
```sql
SELECT COUNT(*) FROM ml_metrics;
SELECT MAX(timestamp) FROM ml_metrics;
```

2. Check time range in Grafana (top right)
3. Verify query syntax in Panel Edit mode
4. Check datasource connection (Settings → Data Sources)

### Issue: Docker mount errors after changing file structure

**Solution:**
```bash
# Complete cleanup
docker-compose down -v
docker system prune -f

# Remove any stale files
rm -rf config/grafana_dashboards.yaml

# Recreate properly
# ... create files ...

# Fresh start
docker-compose up -d
```

## 🔐 Security Considerations

### For Production Deployments:

1. **Change Default Passwords**
```yaml
# docker-compose.yml
environment:
  POSTGRES_PASSWORD: <strong-password>
  GF_SECURITY_ADMIN_PASSWORD: <strong-password>
```

2. **Use Environment Variables**
```bash
# .env file (add to .gitignore!)
POSTGRES_PASSWORD=your_secure_password
GRAFANA_PASSWORD=your_secure_password
```

3. **Restrict Network Access**
- Remove public port bindings
- Use internal Docker networks only
- Add reverse proxy (nginx, traefik)

4. **Enable SSL/TLS**
- Configure PostgreSQL SSL
- Use HTTPS for Grafana
- Encrypt sensitive data

5. **Regular Backups**
```bash
# Backup PostgreSQL
docker-compose exec db pg_dump -U postgres test > backup_$(date +%Y%m%d).sql

# Backup Grafana
docker-compose exec grafana grafana-cli admin reset-admin-password newpassword
```

## 📚 Additional Resources

### Evidently Documentation
- [Evidently Docs](https://docs.evidentlyai.com/)
- [Monitoring Setup](https://docs.evidentlyai.com/user-guide/monitoring)
- [Metric Presets](https://docs.evidentlyai.com/reference/all-metrics)

### Grafana Documentation
- [Grafana Docs](https://grafana.com/docs/grafana/latest/)
- [PostgreSQL Data Source](https://grafana.com/docs/grafana/latest/datasources/postgres/)
- [Dashboard Provisioning](https://grafana.com/docs/grafana/latest/administration/provisioning/)

### PostgreSQL
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Time-Series Best Practices](https://www.postgresql.org/docs/current/queries-table-expressions.html)

## 🛠️ Development Tips

### Hot Reload Dashboard Changes
```bash
# After editing dashboard JSON files
docker-compose restart grafana
```

### View Real-Time Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f grafana
docker-compose logs -f db
```

### Execute SQL Directly
```bash
docker-compose exec db psql -U postgres -d test

# Or from host
docker-compose exec -T db psql -U postgres -d test < query.sql
```

### Interactive Python Testing
```bash
# Install Jupyter in the container
pip install jupyter

# Start notebook server
jupyter notebook --ip=0.0.0.0 --no-browser --allow-root
```

