from fastapi import FastAPI, Request, Form
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv

import mysql.connector

import os

load_dotenv()

app = FastAPI()

# Configure CORS
origins = [
    "http://localhost",
    "http://localhost:8000",
    "http://localhost:3000",  # Add the URL of your Flutter web app
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host=os.getenv("HOST"),
            port=int(os.getenv("PORT")),
            user="admin",
            password=os.getenv("PASSWORD"),
            database=os.getenv("DATABASE")
        )
        return connection
    except Exception as e:
        raise Exception(f"Failed to connect to the database: {str(e)}")

@app.get("/questions")
def get_questions():
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("SELECT quest_id, poll_id, quest_txt FROM questions")
        questions = cursor.fetchall()
        connection.close()
        return {"questions": questions}
    except Exception as e:
        return {"message": "Failed to fetch questions: " + str(e)}

@app.post("/submit-answer")
def submit_answer(quest_id: int = Form(...), answer_text: str = Form(...)):
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("INSERT INTO answers (quest_id, answer_text) VALUES (%s, %s)", (quest_id, answer_text))
        connection.commit()
        connection.close()
        return {"message": "Answer submitted successfully"}
    except Exception as e:
        return {"message": "Failed to submit answer: " + str(e)}
