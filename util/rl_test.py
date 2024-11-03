
import numpy as np
import tensorflow as tf
from classes import Connection, Customer, Refinery, Tanks, Demand
from main import PlayerService
from parser import DataParser
import time

class SupplyChainNetwork(tf.keras.Model):
    def __init__(self, state_size, action_size):
        super(SupplyChainNetwork, self).__init__()
        self.network = tf.keras.Sequential([
            tf.keras.layers.Dense(512, activation='relu', input_shape=(state_size,)),
            tf.keras.layers.BatchNormalization(),
            tf.keras.layers.Dropout(0.2),
            tf.keras.layers.Dense(256, activation='relu'),
            tf.keras.layers.BatchNormalization(),
            tf.keras.layers.Dropout(0.2),
            tf.keras.layers.Dense(128, activation='relu'),
            tf.keras.layers.BatchNormalization(),
            tf.keras.layers.Dense(action_size)
        ])
        
    def call(self, inputs):
        return self.network(inputs)

def play_game(model_path, data_path):
    # Load data
    print("Loading data...")
    data_parser = DataParser(data_path)
    data_parser.load_data()
    
    # Initialize model
    print("Initializing model...")
    state_size = 50
    action_size = 1 + len(data_parser.connections_data) * 10
    model = SupplyChainNetwork(state_size, action_size)
    
    # Build model with dummy data
    dummy_input = np.zeros((1, state_size))
    model(dummy_input)
    
    # Load weights
    model.load_weights(model_path)
    print("Model loaded successfully")
    
    # Initialize service
    service = PlayerService()
    service.start_session()
    print("Session started")
    
    # Play initial round
    day = 0
    response = service.play_round({"day": day, "movements": []})
    print(f"Initial response: {response}")
    
    while day < 42:
        try:
            # Create state
            state = np.zeros(state_size)
            state[0] = day / 42.0  # Normalized day
            
            # Get model prediction
            state_tensor = tf.convert_to_tensor(state[np.newaxis], dtype=tf.float32)
            q_values = model(state_tensor, training=False)

            
            # Select the action with the highest Q-value
            action = tf.argmax(q_values[0]).numpy()
            
            # Convert action to movement
            movements = []
            if action != 0:
                action -= 1
                connection_idx = action % len(data_parser.connections_data)
                amount_level = action // len(data_parser.connections_data)
                connection = data_parser.connections_data[connection_idx]
                amount = (amount_level + 1) * (float(connection.max_capacity) / 10)
                
                movements.append({
                    "connectionId": connection.connection_id,
                    "amount": float(amount)
                })
            
            # Make move
            day += 1
            request = {
                "day": day,
                "movements": movements
            }
            
            print(f"\nDay {day}:")
            print(f"Movements: {movements}")
            
            response = service.play_round(request)
            print(f"Response: {response}")
            
            time.sleep(0.1)  # Small delay between moves
            
        except Exception as e:
            print(f"Error during game: {e}")
            break
    
    # End session
    try:
        service.end_session()
        print("Session ended successfully")
    except:
        print("Failed to end session")


def main():
    model_path = 'best_model_weights.h5'
    data_path = '../data/'
    play_game(model_path, data_path)

if __name__ == "__main__":
    main()
