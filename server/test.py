from main import PlayerService
from json import *

player = PlayerService()

start_message = player.start_session()
# print(start_message)

moves = {
  "day": 1,
  "movements": [
    # {
    #   "connectionId": "3e5f3b05-6bf1-4f8f-9339-9bb76b0be1ad",
    #   "amount": 20
    # }
  ]
}
for i in range(42):
    moves["day"] = i
    play_message = player.play_round(moves)
    # print(play_message)

end_message = player.end_session()
# print(end_message)