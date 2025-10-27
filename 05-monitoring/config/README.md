# Grafana Provisioning Config

This folder contains configuration files for provisioning Grafana sources and dashboards automatically when the monitoring stack starts.

## Files
- `grafana_datasources.yaml` — configures data sources (e.g., PostgreSQL)
- `grafana_dashboards.yaml` — points Grafana to a folder of dashboard JSON files

## How it works
The `docker-compose.yml` in the parent folder mounts this directory into Grafana's provisioning path. On startup, Grafana reads these files and:
- Creates the data source(s)
- Loads dashboards from the configured folder

## Customize
1. Update `grafana_datasources.yaml` with your DB host/port/user/password
2. Put your dashboards JSON into `../dashboards/`
3. Recreate Grafana container or restart it to apply changes

## Troubleshooting
- If Grafana logs show errors, validate YAML syntax
- Ensure file paths in the YAML match the container paths
- If dashboards don't appear, check provisioning timing and folder permissions
