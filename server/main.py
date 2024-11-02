from flask import *
import requests
import json
from errors import *

class PlayerService():
    def __init__(self, api_key = "7bcd6334-bc2e-4cbf-b9d4-61cb9e868869"):
        self.PORT = 8080
        self.BASE_URL = f"http://localhost:{self.PORT}"
        self.API_VERSION = "/api/v1"
        self.api_key = api_key
        self.session_id = None

    def start_session(self):
        if self.session_id:
            return "A session is already active"

        url = f"{self.BASE_URL}{self.API_VERSION}/session/start"
        headers = {
            "accept": "*/*",
            "API-KEY": self.api_key
        }
        response = requests.post(url, headers=headers, data='')

        if response.status_code == 200:
            self.session_id = response.text
            print(self.session_id)
            print("Session started successfully")
        elif response.status_code == 409:
            raise DuplicateSessionError()
        else:
            print("Failed to start session", response.status_code)
            raise FailedSessionError()
        
    def end_session(self):
        if not self.session_id:
            return "No active session to end"

        url = f"{self.BASE_URL}{self.API_VERSION}/session/end"
        headers = {
            "accept": "*/*",
            "API-KEY": self.api_key
        }
        response = requests.post(url, headers=headers, data='')

        if response.status_code == 200:
            self.session_id = None
            print("Session ended successfully")
        elif response.status_code == 409:
            raise NoActiveSessionError()
        else:
            print("Failed to end session", response.status_code)
            raise FailedEndSessionError()
        
    def play_round(self, body):
        if not self.session_id:
            print("No active session to play round")
            raise NoActiveSessionPlayRoundError()

        url = f"{self.BASE_URL}{self.API_VERSION}/play/round"
        headers = {
            "accept": "*/*",
            "API-KEY": self.api_key,
            "SESSION-ID": self.session_id,
            "Content-Type": "application/json"
        }
        if type(body) == dict:
            body = json.dumps(body)
        response = requests.post(url, headers=headers, data=body)

        if response.status_code == 200:
            print("Played round successfully")
            return response.json()
        else:
            raise FailedPlayRoundError()
