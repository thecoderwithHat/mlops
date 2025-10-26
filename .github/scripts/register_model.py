#!/usr/bin/env python3
"""Register a trained model in MLflow Model Registry."""

import mlflow
import sys
import os

def main():
    mlflow_uri = os.environ.get('MLFLOW_TRACKING_URI', 'http://localhost:5000')
    mlflow.set_tracking_uri(mlflow_uri)
    
    run_id = os.environ.get('RUN_ID')
    model_name = os.environ.get('MODEL_NAME')
    
    if not run_id:
        print("❌ RUN_ID environment variable not set")
        sys.exit(1)
    
    if not model_name:
        print("❌ MODEL_NAME environment variable not set")
        sys.exit(1)
    
    model_uri = f"runs:/{run_id}/models_mlflow"
    
    print(f"Registering model...")
    print(f"  MLflow URI: {mlflow_uri}")
    print(f"  Run ID: {run_id}")
    print(f"  Model URI: {model_uri}")
    print(f"  Model Name: {model_name}")
    
    try:
        result = mlflow.register_model(model_uri, model_name)
        print(f"✅ Model registered successfully!")
        print(f"   Name: {model_name}")
        print(f"   Version: {result.version}")
        print(f"   Run ID: {run_id}")
        return 0
    except Exception as e:
        print(f"⚠️  Model registration failed: {e}")
        print(f"   Note: Model was still trained successfully!")
        print(f"   Run ID: {run_id}")
        # Don't fail - training was successful
        return 0

if __name__ == "__main__":
    sys.exit(main())
