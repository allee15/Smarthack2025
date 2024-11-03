import numpy as np
import tensorflow as tf
from collections import deque
import random
import time
from classes import Connection, Customer, Refinery, Tanks, Demand
from main import PlayerService
from parser import DataParser
from collections import defaultdict

class SupplyChainState:
    """Converts game state into features for RL model"""
    def __init__(self, refineries, tanks, customers, connections):
        self.refineries = refineries
        self.tanks = tanks
        self.customers = customers
        self.connections = connections
        self.feature_size = self.calculate_feature_size()
        
    def calculate_feature_size(self):
        # Current day feature
        size = 1
        
        # Per refinery: current stock, capacity, production rate, max output
        size += len(self.refineries) * 4
        
        # Per tank: current stock, capacity, max input, max output
        size += len(self.tanks) * 4
        
        # Per customer: current demand, days until deadline
        size += len(self.customers) * 2
        
        # Per connection: current flow, capacity
        size += len(self.connections) * 2
        
        return size
        
    def get_state(self, day, stocks, active_demands, flows=None):
        features = []
        
        # Normalize day
        features.append(day / 42.0)
        
        # Refinery features
        for ref_id, ref in self.refineries.items():
            current_stock = float(stocks.get(ref_id, 0))
            capacity = float(ref.capacity)
            features.extend([
                current_stock / capacity,  # Normalized stock
                float(ref.production) / capacity,  # Normalized production
                float(ref.max_output) / capacity,  # Normalized max output
                1.0 if current_stock > 0 else 0.0  # Has stock indicator
            ])
        
        # Tank features
        for tank_id, tank in self.tanks.items():
            current_stock = float(stocks.get(tank_id, 0))
            capacity = float(tank.capacity)
            features.extend([
                current_stock / capacity,  # Normalized stock
                float(tank.max_input) / capacity,  # Normalized input rate
                float(tank.max_output) / capacity,  # Normalized output rate
                1.0 if current_stock > 0 else 0.0  # Has stock indicator
            ])
        
        # Customer features
        customer_demands = defaultdict(list)
        for demand in active_demands:
            customer_id = demand.get('customerId')
            amount = float(demand.get('amount', 0))
            end_day = float(demand.get('endDay', 0))
            customer_demands[customer_id].append((amount, end_day))
            
        for cust_id, cust in self.customers.items():
            if cust_id in customer_demands:
                # Take most urgent demand
                amount, end_day = min(customer_demands[cust_id], key=lambda x: x[1])
                features.extend([
                    amount / float(cust.max_input),  # Normalized demand
                    (end_day - day) / 42.0  # Normalized time until deadline
                ])
            else:
                features.extend([0.0, 0.0])  # No demand
        
        # Connection features
        flows = flows or {}
        for conn in self.connections:
            current_flow = float(flows.get(conn.connection_id, 0))
            max_capacity = float(conn.max_capacity)
            features.extend([
                current_flow / max_capacity,  # Normalized flow
                1.0 if current_flow < max_capacity else 0.0  # Has capacity indicator
            ])
        
        return np.array(features, dtype=np.float32)

class SupplyChainAction:
    """Handles action space for the RL model"""
    def __init__(self, connections):
        self.connections = connections
        # Action space: no movement + (connections × 10 amount levels)
        self.action_size = 1 + len(connections) * 10
        
    def action_to_movement(self, action_idx):
        if action_idx == 0:
            return []
            
        action_idx -= 1
        connection_idx = action_idx % len(self.connections)
        amount_level = action_idx // len(self.connections)
        
        connection = self.connections[connection_idx]
        max_amount = float(connection.max_capacity)
        amount = (amount_level + 1) * (max_amount / 10)
        
        return [{
            "connectionId": connection.connection_id,
            "amount": float(amount)
        }]
class SupplyChainEnvironment:
    def __init__(self, data_parser):
        # Game elements
        self.refineries = {ref: ref for ref in data_parser.refineries_data}
        self.tanks = {tank: tank for tank in data_parser.tanks_data}
        self.connections = {conn: conn for conn in data_parser.connections_data}
        self.customers = {cust: cust for cust in data_parser.customers_data}
        
        # State and action handlers
        self.state_handler = SupplyChainState(self.refineries, self.tanks, self.customers, self.connections)
        self.action_handler = SupplyChainAction(list(self.connections.values()))
        
        # Game state
        self.day = 0
        self.next_day = 0
        self.stocks = {}
        self.active_demands = []

    def reset(self):
        """Reset environment for new episode with fresh PlayerService"""
        print("\nResetting environment...")
        
        # Create new PlayerService instance for each episode
        self.player_service = PlayerService()
        
        try:
            # Start new session
            print("Starting new session...")
            self.player_service.start_session()
            print(f"New session started successfully")
            
            # Reset state
            self.day = 0
            self.next_day = 0
            self.stocks = {
                **{ref.refinery_id: float(ref.initial_stock) for ref in self.refineries.values()},
                **{tank.tank_id: float(tank.initial_stock) for tank in self.tanks.values()}
            }
            self.active_demands = []
            
            # Play initial round
            initial_response = self.player_service.play_round({"day": self.day, "movements": []})
            print(f"Initial round played successfully")
            
            # Update state from response
            self.update_state_from_response(initial_response)
            
            return self.state_handler.get_state(self.day, self.stocks, self.active_demands)
            
        except Exception as e:
            print(f"Error in reset: {e}")
            self.player_service = None
            return self.state_handler.get_state(0, {}, [])

    def update_state_from_response(self, response):
        """Update internal state based on server response"""
        try:
            self.active_demands = response.get('demand', [])
            current_round = response.get('round', 0)
            self.day = current_round
            self.next_day = current_round + 1
            
            # Update stocks if available
            if 'nodes' in response:
                for node_id, node_data in response['nodes'].items():
                    self.stocks[node_id] = float(node_data.get('stock', self.stocks.get(node_id, 0)))
                    
            print(f"State updated - Day: {self.day}, Next Day: {self.next_day}")
            
        except Exception as e:
            print(f"Error updating state: {e}")

    def step(self, action):
        """Execute one step in the environment"""
        try:
            if not hasattr(self, 'player_service') or self.player_service is None:
                print("No active player service, ending episode")
                return self.state_handler.get_state(self.day, self.stocks, self.active_demands), -10000, True, None
            
            # Convert action to movement
            movements = self.action_handler.action_to_movement(action)
            
            # Prepare request
            request = {
                "day": self.next_day,
                "movements": movements
            }
            
            print(f"\nExecuting move for day {self.next_day}")
            print(f"Movements: {movements}")
            
            # Execute move
            response = self.player_service.play_round(request)
            print(f"Move executed successfully")
            
            # Update state
            self.update_state_from_response(response)
            
            # Calculate reward
            reward = -(float(response['deltaKpis']['cost']) + float(response['deltaKpis']['co2']))
            
            # Add penalties
            for penalty in response.get('penalties', []):
                reward -= (float(penalty['cost']) + float(penalty['co2']))
            
            # Check if done
            done = self.day >= 42
            
            if done:
                try:
                    print("Episode complete, ending session")
                    self.player_service.end_session()
                except:
                    pass
                finally:
                    self.player_service = None
            
            next_state = self.state_handler.get_state(self.day, self.stocks, self.active_demands)
            return next_state, reward, done, response
            
        except Exception as e:
            print(f"Error during step: {e}")
            try:
                if hasattr(self, 'player_service') and self.player_service is not None:
                    self.player_service.end_session()
            except:
                pass
            self.player_service = None
            return self.state_handler.get_state(self.day, self.stocks, self.active_demands), -10000, True, None

def train_model(env, episodes=1000, batch_size=32, gamma=0.99):
    """Train the RL model"""
    state_size = env.state_handler.feature_size
    action_size = env.action_handler.action_size
    
    print(f"Training with state size: {state_size}, action size: {action_size}")
    
    # Create model
    model = tf.keras.Sequential([
        tf.keras.layers.Dense(512, activation='relu', input_shape=(state_size,)),
        tf.keras.layers.BatchNormalization(),
        tf.keras.layers.Dense(256, activation='relu'),
        tf.keras.layers.BatchNormalization(),
        tf.keras.layers.Dense(128, activation='relu'),
        tf.keras.layers.BatchNormalization(),
        tf.keras.layers.Dense(action_size)
    ])
    
    # Target network
    target_model = tf.keras.models.clone_model(model)
    target_model.set_weights(model.get_weights())
    
    optimizer = tf.keras.optimizers.legacy.Adam(learning_rate=0.0001)
    memory = deque(maxlen=100000)
    epsilon = 1.0
    epsilon_min = 0.01
    epsilon_decay = 0.995
    
    best_reward = float('-inf')
    
    for episode in range(episodes):
        print(f"\nStarting episode {episode + 1}/{episodes}")
        state = env.reset()
        total_reward = 0
        steps = 0
        
        while True:
            # Choose action
            if random.random() < epsilon:
                action = random.randrange(action_size)
            else:
                q_values = model.predict(state[np.newaxis], verbose=0)
                action = np.argmax(q_values[0])
            
            # Take action
            next_state, reward, done, response = env.step(action)
            total_reward += reward
            steps += 1
            
            # Store experience
            memory.append((state, action, reward, next_state, done))
            state = next_state
            
            # Train
            if len(memory) >= batch_size:
                batch = random.sample(memory, batch_size)
                states = np.array([x[0] for x in batch])
                actions = np.array([x[1] for x in batch])
                rewards = np.array([x[2] for x in batch])
                next_states = np.array([x[3] for x in batch])
                dones = np.array([x[4] for x in batch])
                
                # Q-learning update
                target_q_values = target_model.predict(next_states, verbose=0)
                max_q_values = np.max(target_q_values, axis=1)
                targets = rewards + (1 - dones) * gamma * max_q_values
                
                with tf.GradientTape() as tape:
                    q_values = model(states)
                    q_action = tf.reduce_sum(
                        q_values * tf.one_hot(actions, action_size),
                        axis=1
                    )
                    loss = tf.keras.losses.Huber()(targets, q_action)
                
                gradients = tape.gradient(loss, model.trainable_variables)
                optimizer.apply_gradients(zip(gradients, model.trainable_variables))
            
            if done:
                break
        
        # Update target network
        if episode % 10 == 0:
            target_model.set_weights(model.get_weights())
        
        # Decay epsilon
        epsilon = max(epsilon_min, epsilon * epsilon_decay)
        
        print(f"Episode {episode + 1}/{episodes}")
        print(f"Steps: {steps}")
        print(f"Total Reward: {total_reward:.2f}")
        print(f"Epsilon: {epsilon:.2f}")
        
        # Save if best
        if total_reward > best_reward:
            best_reward = total_reward
            model.save_weights('best_model.h5')
            print(f"New best model saved with reward: {best_reward:.2f}")
        
        # Small delay between episodes
        time.sleep(0.1)

def main():
    # Load data
    print("Loading data...")
    data_parser = DataParser("../data/")
    data_parser.load_data()
    
    # Create environment
    env = SupplyChainEnvironment(data_parser)
    
    # Train model
    train_model(env, episodes=50)

if __name__ == "__main__":
    main() 