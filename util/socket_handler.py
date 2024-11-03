import socket
import json
from flask_apscheduler import APScheduler
from parser import *
import time
import random

# Global variables
initialized_socket = False
sock = None
max_retries = 5
retry_delay = 1

def initialize_socket():
    global sock
    global initialized_socket
    
    if not initialized_socket:
        for attempt in range(max_retries):
            try:
                sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                sock.settimeout(5)  # Set a timeout of 5 seconds
                sock.connect(('127.0.0.1', 5000))
                print("Connected to socket")
                initialized_socket = True
                return
            except Exception as e:
                print(f"Socket error during initialization (attempt {attempt + 1}/{max_retries}): {e}")
                if attempt < max_retries - 1:
                    delay = retry_delay * (2 ** attempt)
                    print(f"Retrying in {delay:.2f} seconds...")
                    time.sleep(delay)
                else:
                    raise

def send_periodic_data():
    global sock
    if sock:
        try:
            print("Sending data")
            connections_path = basePath + 'connections.csv'
            connections_data = list(parse_connections(connections_path))

            customers_path = basePath + 'customers.csv'
            customers_data = list(parse_customers(customers_path))

            refineries_path = basePath + 'refineries.csv'
            refineries_data = list(parse_refineries(refineries_path))

            tanks_path = basePath + 'tanks.csv'
            tanks_data = list(parse_tanks(tanks_path))

            send_to_socket({"connections": [connection.to_dict() for connection in connections_data]})
            send_to_socket({"customers": [customer.to_dict() for customer in customers_data]})
            send_to_socket({"refineries": [refinery.to_dict() for refinery in refineries_data]})
            send_to_socket({"tanks": [tank.to_dict() for tank in tanks_data]})
        except socket.error as e:
            print(f"Socket error sending data: {e}")
            reconnect()
        except Exception as e:
            print(f"Unexpected error sending data: {e}")

def send_to_socket(data):
    try:
        sock.sendall(json.dumps(data).encode())
        print(f"Sent data:")
    except Exception as e:
        print(f"Error sending data: {e}")
        reconnect()

def reconnect():
    global initialized_socket
    global sock
    if not initialized_socket:
        print("Reconnecting...")
        initialize_socket()
    else:
        print("Closing existing connection...")
        sock.close()
        initialized_socket = False
        initialize_socket()

if __name__ == '__main__':
    initialize_socket()
    
    while True:
        send_periodic_data()
        time.sleep(3)

    # scheduler = APScheduler()
    # scheduler.init_app(app)
    # scheduler.add_job(periodic_send, 'interval', id='send_data', seconds=3)
    # scheduler.start()
