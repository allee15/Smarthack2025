class DuplicateSessionError(Exception):
    def __init__(self, message="A session is already active"):
        super().__init__(message)

class NoActiveSessionError(Exception):
    def __init__(self, message="No active session to end"):
        super().__init__(message)

class FailedSessionError(Exception):
    def __init__(self, message="Failed to start session"):
        super().__init__(message)

class FailedEndSessionError(Exception):
    def __init__(self, message="Failed to end session"):
        super().__init__(message)

class NoActiveSessionPlayRoundError(Exception):
    def __init__(self, message="No active session to play round"):
        super().__init__(message)

class FailedPlayRoundError(Exception):
    def __init__(self, message="Failed to play round"):
        super().__init__(message)