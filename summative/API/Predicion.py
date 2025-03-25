import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import SGDRegressor
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_squared_error
import matplotlib.pyplot as plt
import joblib

# Loading the dataset
url = "https://raw.githubusercontent.com/ikalisa1/linear_regression_model/refs/heads/main/day.csv"
df = pd.read_csv(url)

# Separating features of (X) and target (y)
X = df.drop(columns=['cnt'])  # all columns except 'cnt'
y = df['cnt']  # target variable

# Spliting the data into train and test sets (80% train, 20% test)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Scaling features for better performance with gradient descent
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Try different max_iter values to plot the loss curve
train_loss = []
test_loss = []
iteration_list = [100, 500, 1000, 3000]

for max_iter in iteration_list:
    model = SGDRegressor(max_iter=max_iter, alpha=0.001, random_state=42)
    model.fit(X_train_scaled, y_train)
    
    # Calculating MSE on train and test sets
    y_train_pred = model.predict(X_train_scaled)
    y_test_pred = model.predict(X_test_scaled)
    train_loss.append(mean_squared_error(y_train, y_train_pred))
    test_loss.append(mean_squared_error(y_test, y_test_pred))

# Ploting train vs test loss curve
plt.figure(figsize=(8, 5))
plt.plot(iteration_list, train_loss, marker='o', label='Train Loss (MSE)')
plt.plot(iteration_list, test_loss, marker='s', label='Test Loss (MSE)')
plt.xlabel("Max Iterations")
plt.ylabel("Mean Squared Error")
plt.title("Loss Curve for SGDRegressor on Bike Rental Data")
plt.legend()
plt.grid(True)
plt.show()

# Training final model using best iteration (1000 used here)
final_model = SGDRegressor(max_iter=1000, alpha=0.001, random_state=42)
final_model.fit(X_train_scaled, y_train)

# Saving the model and scaler for use in the FastAPI app
joblib.dump(final_model, "model.pkl")
joblib.dump(scaler, "scaler.pkl")

# Model training is now completed and saved as model.pkl and scaler.pkl"