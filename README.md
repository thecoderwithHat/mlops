# MLOps:

This repository contains a complete MLOps pipeline for training, deploying, and monitoring a machine learning model to predict the duration of NYC Green Taxi trips.

[![CI/CD Pipeline](https://github.com/thecoderwithHat/mlops/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/thecoderwithHat/mlops/actions/workflows/ci-cd.yml)
[![Model Training Pipeline](https://github.com/thecoderwithHat/mlops/actions/workflows/train-model.yml/badge.svg)](https://github.com/thecoderwithHat/mlops/actions/workflows/train-model.yml)
[![Model Monitoring](https://github.com/thecoderwithHat/mlops/actions/workflows/monitor-model.yml/badge.svg)](https://github.com/thecoderwithHat/mlops/actions/workflows/monitor-model.yml)

## Table of Contents
- [Project Overview](#project-overview)
- [Project Structure](#project-structure)
- [MLOps Pipeline Stages](#mlops-pipeline-stages)
  - [1. Experiment Tracking](#1-experiment-tracking)
  - [2. Orchestration](#2-orchestration)
  - [3. Deployment](#3-deployment)
  - [4. Monitoring](#4-monitoring)
- [CI/CD Automation](#cicd-automation)
- [Monitoring Stack](#monitoring-stack)
- [Getting Started](#getting-started)
- [Learning Journey](#learning-journey)
- [Key Technologies](#key-technologies)
- [How to Contribute](#how-to-contribute)

## Project Overview

The goal of this project is to build a robust, end-to-end MLOps system. We use public data for NYC Green Taxi trips to train a model that predicts trip duration. The project covers the entire machine learning lifecycle, from initial experimentation and model training to automated deployment and continuous monitoring for performance degradation and data drift.

### Conceptual Workflow

```
+----------------------+      +---------------------+      +------------------+      +-----------------+
|                      |      |                     |      |                  |      |                 |
|  Experimentation     +----->+  Orchestration      +----->+   Deployment     +----->+   Monitoring    |
|  (Jupyter, MLflow)   |      |  (Python Scripts)   |      |   (Batch/API)    |      |   (Evidently)   |
|                      |      |                     |      |                  |      |                 |
+----------+-----------+      +----------+----------+      +--------+---------+      +--------+--------+
           ^                       ^                               ^                       |
           |                       |                               |                       |
           |                       |                               |                       |
           +-----------------------+-------------------------------+-----------------------+
                                   |
                         +---------v---------+
                         |                   |
                         |   CI/CD Pipeline  |
                         |  (GitHub Actions) |
                         |                   |
                         +-------------------+
```

## Project Structure

The repository is organized into modules, each representing a key stage in the MLOps lifecycle.

```
.
├── .github/                  # GitHub Actions workflows and scripts
├── 02-experiment-tracking/   # Notebooks for MLflow experimentation
├── 03-orchestration/         # Scripts for model training and orchestration
├── 04-deployment/            # Deployment scripts (batch, web service)
├── 05-monitoring/            # Monitoring setup (Docker, Grafana, Evidently)
├── mlartifacts/              # MLflow artifacts (local storage)
└── README.md
```

- **`.github/`**: Contains all CI/CD workflow definitions (`ci-cd.yml`, `train-model.yml`, etc.) and helper scripts for automation.
- **`02-experiment-tracking/`**: Jupyter notebooks for initial data exploration and model experimentation using MLflow to track runs.
- **`03-orchestration/`**: Python scripts that formalize the training process, making it repeatable and orchestrable.
- **`04-deployment/`**: Contains code for deploying the model in two ways:
    - `batch/`: A batch scoring script that predicts on a large dataset.
    - `web-services/`: A Flask application to serve real-time predictions.
- **`05-monitoring/`**: Configuration for the monitoring stack, including `docker-compose.yml` to launch Grafana, PostgreSQL, and Adminer, and dashboard configurations for visualizing model performance and drift.
- **`mlartifacts/`**: The local directory used by MLflow to store model artifacts, metrics, and parameters when running workflows.

## MLOps Pipeline Stages

### 1. Experiment Tracking

- **Goal**: Track experiments to find the best model.
- **Tools**: Jupyter, MLflow
- **Process**: Notebooks in `02-experiment-tracking` are used to explore the data, preprocess features, and train different models. MLflow is used to log parameters, metrics (like RMSE), and model artifacts for each run, allowing for easy comparison and model selection.

### 2. Orchestration

- **Goal**: Automate the model training process.
- **Tools**: Python, MLflow
- **Process**: The `03-orchestration/duration-prediction.py` script operationalizes the best model found during experimentation. It can be run automatically to train the model on new data, find the best run, and prepare it for registration.

### 3. Deployment

The model is deployed in two primary ways:

- **Batch Scoring (`04-deployment/batch/`)**: A script (`score.py`) loads a trained model from the MLflow Model Registry and applies it to a month's worth of taxi data, saving the predictions.
- **Web Service (`04-deployment/web-services/`)**: A Flask application (`predict.py`) serves the model via a REST API. It exposes a `/predict` endpoint that takes taxi trip data as input and returns a trip duration prediction in real-time.

### 4. Monitoring

- **Goal**: Continuously monitor the deployed model for data drift and performance degradation.
- **Tools**: Evidently AI, PostgreSQL, Grafana, Docker Compose
- **Process**:
    1. A scheduled GitHub Actions workflow (`monitor-model.yml`) runs periodically.
    2. It generates a monitoring report using Evidently AI, comparing current data to a reference dataset.
    3. Metrics (like data drift and feature statistics) are stored in a PostgreSQL database.
    4. Grafana is used to visualize these metrics over time, providing dashboards to observe the model's health. If drift is detected, an alert is created as a GitHub issue.

## CI/CD Automation

The entire MLOps lifecycle is automated using GitHub Actions.

- **`ci-cd.yml`**: The main CI/CD pipeline triggered on every push to `main`. It performs:
    - Linting and code formatting checks.
    - Unit and integration tests across multiple Python versions (3.9, 3.10, 3.11).
    - Security scanning with Trivy and `pip-audit`.
    - Building and pushing Docker images to GitHub Container Registry (GHCR).

- **`train-model.yml`**: A manually triggerable workflow to train, validate, and register the model in MLflow. It generates a model card and uploads all artifacts.
    - **To Run**: Go to the "Actions" tab, select "Model Training Pipeline", and click "Run workflow".

- **`monitor-model.yml`**: A scheduled workflow that runs every 6 hours to monitor the production model for drift. It can also be triggered manually.

- **`deploy-service.yml`**: A workflow for deploying the web service, supporting canary deployments to staging and production environments.

## Monitoring Stack

The monitoring infrastructure is defined in `05-monitoring/docker-compose.yml` and can be launched with:

```bash
docker compose -f 05-monitoring/docker-compose.yml up -d
```

This starts three services:
- **Grafana**: For data visualization and dashboards. Access at `http://localhost:3000`.
- **PostgreSQL**: To store the monitoring metrics generated by Evidently.
- **Adminer**: A lightweight database management tool. Access at `http://localhost:8080`.

## Getting Started

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/thecoderwithHat/mlops.git
    cd mlops
    ```

2.  **Set up the environment:**
    This project uses `pip` for dependency management. It is recommended to use a virtual environment.
    ```bash
    python -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt 
    # Install requirements for specific modules as needed
    ```

3.  **Run the Model Training Pipeline:**
    Navigate to the [Actions tab](https://github.com/thecoderwithHat/mlops/actions/workflows/train-model.yml) in the GitHub repository, select the "Model Training Pipeline" workflow, and click "Run workflow". This simulates a manual model promotion to production.

4.  **Launch the Monitoring Stack:**
    ```bash
    docker compose -f 05-monitoring/docker-compose.yml up -d
    ```
    - Grafana UI: `http://localhost:3000` (login with `admin`/`admin`)
    - Adminer: `http://localhost:8080`

## Learning Journey

This repository is designed to be a learning resource. Here’s a suggested path to follow to understand the project from the ground up:

1.  **Start with Experimentation (`02-experiment-tracking`)**:
    - Run the `duration-prediction.ipynb` notebook.
    - Understand how MLflow is used to track different model runs.
    - See how parameters and metrics are logged.

2.  **Move to Orchestration (`03-orchestration`)**:
    - Examine `duration-prediction.py`. Notice how it refactors the notebook code into a reusable script.
    - This step is crucial for moving from interactive development to automated, repeatable training runs.

3.  **Explore Deployment Options (`04-deployment`)**:
    - **Web Service**: Look at `web-services/predict.py` to see how a trained model is loaded and wrapped in a Flask API for real-time predictions.
    - **Batch Scoring**: Check `batch/score.py` to understand how to apply the model to a large dataset for offline processing.

4.  **Understand Monitoring (`05-monitoring`)**:
    - Review `docker-compose.yml` to see how the monitoring services (Grafana, PostgreSQL) are defined.
    - Look at the `monitor-model.yml` workflow to see how Evidently AI is used to generate drift reports on a schedule.

5.  **Dive into CI/CD (`.github/workflows`)**:
    - Analyze `ci-cd.yml` to see how code quality, testing, and security are automated.
    - Follow the logic in `train-model.yml` to understand the end-to-end process of training, validating, and registering a model in an automated fashion.

## Key Technologies

- **ML Framework**: Scikit-learn, XGBoost
- **Experiment Tracking**: MLflow
- **Deployment**: Docker, Flask
- **CI/CD**: GitHub Actions
- **Monitoring**: Evidently AI, Grafana, PostgreSQL
- **Code Quality**: Black, isort, Flake8
- **Testing**: pytest, coverage
- **Security**: Trivy, pip-audit

## How to Contribute

Contributions are welcome! This project is a great place to learn and experiment with MLOps practices.

1.  **Fork the repository.**
2.  **Create a new branch** (`git checkout -b feature/your-feature-name`).
3.  **Make your changes.**
4.  **Commit your changes** (`git commit -m 'Add some feature'`).
5.  **Push to the branch** (`git push origin feature/your-feature-name`).
6.  **Open a Pull Request.**

Please ensure your code adheres to the existing style and that all tests pass.
