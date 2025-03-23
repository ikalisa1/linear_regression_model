from fastapi import FastAPI
from pydantic import BaseModel, Field
import numpy as np
import joblib
from fastapi.middleware.cors import CORSMiddleware

# Loading the trained model and scaler
model = joblib.load("model.pkl")
scaler = joblib.load("scaler.pkl")

# Creation of the FastAPI app
app = FastAPI(
    title="Bike Rental Prediction API",
    description="Predicts total bike rentals per day using linear regression",
    version="1.0.0"
)

# Enabling CORS (so my API can be called from web apps, and others...)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # You can restrict to your frontend URL later
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Defining the expected input structure by using Pydantic
class BikeData(BaseModel):
    season: int = Field(..., ge=1, le=4, description="1 = winter, 2 = spring, 3 = summer, 4 = fall")
    yr: int = Field(..., ge=0, le=1, description="0 = 2011, 1 = 2012")
    mnth: int = Field(..., ge=1, le=12, description="Month (1 to 12)")
    holiday: int = Field(..., ge=0, le=1, description="0 = no, 1 = yes")
    weekday: int = Field(..., ge=0, le=6, description="0 = Sunday, 6 = Saturday")
    workingday: int = Field(..., ge=0, le=1, description="0 = no, 1 = yes")
    weathersit: int = Field(..., ge=1, le=4, description="1 = Clear, 4 = Heavy rain")
    temp: float = Field(..., ge=0.0, le=1.0, description="Normalized temperature")
    atemp: float = Field(..., ge=0.0, le=1.0, description="Normalized feeling temperature")
    hum: float = Field(..., ge=0.0, le=1.0, description="Normalized humidity")
    windspeed: float = Field(..., ge=0.0, le=1.0, description="Normalized windspeed")

# Creating the prediction endpoint
@app.post("/predict")
def predict_bike_rentals(data: BikeData):
    # Converting input into NumPy array
    input_array = np.array([[
        data.season,
        data.yr,
        data.mnth,
        data.holiday,
        data.weekday,
        data.workingday,
        data.weathersit,
        data.temp,
        data.atemp,
        data.hum,
        data.windspeed
    ]])

    # Scale input data
    input_scaled = scaler.transform(input_array)

    # Making predictions
    prediction = model.predict(input_scaled)[0]

    return {
        "predicted_rentals": round(prediction, 2),
        "note": "This is a predicted number of total daily bike rentals."
    }


