from sklearn.ensemble import RandomForestClassifier
import joblib
import numpy as np

X = [[1,1,0,0,0,0], [0,0,1,1,0,0], [0,0,0,0,1,1], [1,1,1,0,0,1]]
y = ["Flu", "Food Poisoning", "Allergy", "Covid"]

model = RandomForestClassifier()
model.fit(X, y)
joblib.dump(model, "model.pkl")
