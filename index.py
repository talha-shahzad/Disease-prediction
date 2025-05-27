import joblib
from flask import Flask, request, render_template_string

import threading
import webbrowser

SYMPTOMS = ['fever', 'cough', 'fatigue', 'diarrhea', 'rash', 'headache']
model = joblib.load("model.pkl")

app = Flask(__name__)

HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>Disease Predictor</title>
    <link rel="stylesheet" href="/static/style.css">
</head>
<body>
    <div class="container">
        <h2>Disease Prediction</h2>
        <form method="POST">
            {% for symptom in symptoms %}
                <label><input type="checkbox" name="{{ symptom }}"> {{ symptom.capitalize() }}</label>
            {% endfor %}
            <button type="submit">Predict</button>
        </form>
        {% if prediction %}
            <div class="result">Predicted Disease: {{ prediction }}</div>
        {% endif %}
    </div>
</body>
</html>
"""

@app.route("/", methods=["GET", "POST"])
def home():
    prediction = None
    if request.method == "POST":
        user_input = [1 if s in request.form else 0 for s in SYMPTOMS]
        prediction = model.predict([user_input])[0]
    return render_template_string(HTML_TEMPLATE, symptoms=SYMPTOMS, prediction=prediction)


def open_browser():
    webbrowser.open_new("http://127.0.0.1:5000/")

if __name__ == "__main__":
    threading.Timer(1.0, open_browser).start()
    app.run(debug=False)

