# app.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return "Hey, Im responding as Expected. Have a nice a day...!!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
