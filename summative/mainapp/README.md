Bike Rental Prediction - Google Colab ReadMe

Overview

This project involves predicting bike rental demand using machine learning models, including Linear Regression, Random Forest, and Decision Trees. The model is trained and tested in Google Colab, leveraging Python libraries such as scikit-learn, pandas, and matplotlib. The final model is deployed via a FastAPI backend, which the Flutter mobile application interacts with for real-time predictions.

Features

Data Preprocessing: Handles missing values, feature scaling, and encoding categorical variables.

Model Training & Evaluation: Implements Linear Regression, Decision Trees, and Random Forest models, evaluating them using RMSE (Root Mean Squared Error).

Hyperparameter Tuning: Optimizes model parameters for better performance.

Deployment: The trained model is exported and served using a FastAPI backend.

Integration with Flutter: The API is consumed by a Flutter mobile application to provide bike rental demand predictions.

Files & Structure

bike_rental_colab.ipynb - Google Colab notebook for data preprocessing, model training, and evaluation.

model.pkl - Saved machine learning model for API deployment.

requirements.txt - List of dependencies needed to run the notebook.
