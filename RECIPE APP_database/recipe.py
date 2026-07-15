from flask import Flask, render_template, request, redirect
from pymongo import MongoClient

app = Flask(__name__)

# MongoDB connection
client = MongoClient("mongodb://localhost:27017/")
db = client["recipe_db"]
collection = db["recipes"]

print("Server Started ✔")

# HOME PAGE
@app.route("/")
def home():
    recipes = collection.find()
    return render_template("index.html", recipes=recipes)

# ADD RECIPE
@app.route("/add", methods=["POST"])
def add():
    data = {
        "name": request.form["name"],
        "ingredients": request.form["ingredients"],
        "instructions": request.form["instructions"]
    }
    collection.insert_one(data)
    return redirect("/")

# SEARCH RECIPE
@app.route("/search", methods=["POST"])
def search():
    name = request.form["name"]
    recipe = collection.find_one({"name": name})
    recipes = collection.find()
    return render_template("index.html", recipe=recipe, recipes=recipes)

# DELETE RECIPE
@app.route("/delete", methods=["POST"])
def delete():
    name = request.form["name"]
    collection.delete_one({"name": name})
    return redirect("/")

if __name__ == "__main__":
    app.run(debug=True)