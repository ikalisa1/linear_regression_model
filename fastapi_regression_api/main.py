import joblib
import numpy as np
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import uvicorn

# Load the trained model
model = joblib.load("model.pkl")

# Initialize FastAPI app
app = FastAPI()

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allow all HTTP methods
    allow_headers=["*"],  # Allow all headers
)

# Define Input Schema
class InputData(BaseModel):
    age: float = Field(..., gt=0, description="Age of the policyholder")
    annual_premium: float = Field(..., gt=0, description="Annual premium cost")
    number_of_policies: int = Field(..., ge=1, description="Number of insurance policies")
    vehicle_age: float = Field(..., ge=0, description="Age of the vehicle in years")

@app.post("/predict")
def predict(data: InputData):
    input_array = np.array([[data.age, data.annual_premium, data.number_of_policies, data.vehicle_age]])
    prediction = model.predict(input_array)
    return {"predicted_claim_amount": prediction[0]}

# Run the API
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
