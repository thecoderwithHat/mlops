# Duration Prediction Orchestration

This directory contains the implementation of the duration prediction orchestration pipeline. The pipeline is designed to predict the duration of events using machine learning models and orchestrates the workflow for preprocessing, training, and evaluation.

## Files and Directories

- **`duration-prediction.py`**: The main Python script that contains the orchestration logic for the duration prediction pipeline.
- **`duration-prediction.ipynb`**: A Jupyter Notebook for experimenting with and visualizing the duration prediction pipeline.
- **`run_id.txt`**: A file that stores the run ID of the most recent pipeline execution.
- **`mlartifacts/`**: Directory containing artifacts generated during the pipeline execution, such as preprocessor files and trained models.
  - **`artifacts/`**: Stores intermediate artifacts like preprocessors.
  - **`models/`**: Stores trained models along with their metadata (e.g., `MLmodel`, `conda.yaml`, `python_env.yaml`, etc.).

## How to Use

1. **Install Dependencies**:
   Ensure you have all the required dependencies installed. You can use the `requirements.txt` file in the parent directory to install them:
   ```bash
   pip install -r ../requirements.txt
   ```

2. **Run the Pipeline**:
   Execute the `duration-prediction.py` script to run the pipeline. You can pass arguments to customize the execution. For example:
   ```bash
   python duration-prediction.py --arg1 value1 --arg2 value2
   ```
   Replace `--arg1` and `--arg2` with the actual argument names and their respective values. Refer to the script documentation or source code for the list of supported arguments.

3. **Check Artifacts**:
   After execution, the generated artifacts (e.g., preprocessors, models) will be available in the `mlartifacts/` directory.

4. **Experiment with the Notebook**:
   Open the `duration-prediction.ipynb` notebook to experiment with the pipeline and visualize results:
   ```bash
   jupyter notebook duration-prediction.ipynb
   ```

## Directory Structure

```
03-orchestration/
├── duration-prediction.ipynb
├── duration-prediction.py
├── run_id.txt
├── mlartifacts/
│   ├── 1/
│   │   ├── <run_id>/
│   │   │   ├── artifacts/
│   │   │   │   └── preprocessor/
│   │   │   │       └── preprocessor.b
│   │   │   ├── models/
│   │   │       ├── m-<model_id>/
│   │   │       │   ├── conda.yaml
│   │   │       │   ├── MLmodel
│   │   │       │   ├── model.xgb
│   │   │       │   ├── python_env.yaml
│   │   │       │   └── requirements.txt
├── models/
│   └── preprocessor.b
```

## Notes

- Ensure that the `mlflow` library is properly configured if you are using it for tracking experiments and managing models.
- The `run_id.txt` file is used to keep track of the last executed pipeline run. Make sure it is updated correctly during each execution.

## License

This project is licensed under the MIT License. See the LICENSE file for details.