import csv
from classes import Connection, Customer, Refinery, Tanks, Demand

def parse_connections(file_path):
    with open(file_path, 'r') as file:
        csv_reader = csv.reader(file,delimiter=';', quotechar='"')
        
        next(csv_reader, None)
        
        for row in csv_reader:
            try:
                yield Connection(
                    row[0],
                    row[1],
                    row[2],
                    row[3],
                    row[4],
                    row[5],
                    row[6]
                )
            except IndexError as e:
                print(f"Error processing row {row}: {e}")
                continue

connections_path = '/Users/mready/Downloads/challenge-main/eval-platform/src/main/resources/liquibase/data/connections.csv'
connections_data = list(parse_connections(connections_path))

def parse_customers(file_path):
    with open(file_path, 'r') as file:
        csv_reader = csv.reader(file,delimiter=';', quotechar='"')
        
        next(csv_reader, None)
        
        for row in csv_reader:
            try:
                yield Customer(
                    row[0],
                    row[1],
                    row[2],
                    row[3],
                    row[4],
                    row[5],
                    row[6]
                )
            except IndexError as e:
                print(f"Error processing row {row}: {e}")
                continue

customers_path = '/Users/mready/Downloads/challenge-main/eval-platform/src/main/resources/liquibase/data/customers.csv'
customers_data = list(parse_customers(customers_path))

def parse_refineries(file_path):
    with open(file_path, 'r') as file:
        csv_reader = csv.reader(file,delimiter=';', quotechar='"')
        
        next(csv_reader, None)
        
        for row in csv_reader:
            try:
                yield Refinery(
                    row[0],
                    row[1],
                    row[2],
                    row[3],
                    row[4],
                    row[5],
                    row[6],
                    row[7],
                    row[8],
                    row[9],
                    row[10],
                    row[11]
                )
            except IndexError as e:
                print(f"Error processing row {row}: {e}")
                continue

refineries_path = '/Users/mready/Downloads/challenge-main/eval-platform/src/main/resources/liquibase/data/refineries.csv'
refineries_data = list(parse_refineries(refineries_path))

def parse_tanks(file_path):
    with open(file_path, 'r') as file:
        csv_reader = csv.reader(file,delimiter=';', quotechar='"')
        
        next(csv_reader, None)
        
        for row in csv_reader:
            try:
                yield Tanks(
                    row[0],
                    row[1],
                    row[2],
                    row[3],
                    row[4],
                    row[5],
                    row[6],
                    row[7],
                    row[8],
                    row[9],
                    row[10]
                )
            except IndexError as e:
                print(f"Error processing row {row}: {e}")
                continue 

tanks_path = '/Users/mready/Downloads/challenge-main/eval-platform/src/main/resources/liquibase/data/tanks.csv'
tanks_data = list(parse_tanks(tanks_path))

def parse_first_demands(file_path):
    with open(file_path, 'r') as file:
        csv_reader = csv.reader(file,delimiter=';', quotechar='"')
        
        next(csv_reader, None)
        for row in csv_reader:
            try:
                if float(row[3]) == 0:
                    yield Demand(
                        row[0],
                        row[1],
                        row[2],
                        row[3],
                        row[4],
                        row[5],
                    )
            except IndexError as e:
                print(f"Error processing row {row}: {e}")
                continue

first_demands_path = '/Users/mready/Downloads/challenge-main/eval-platform/src/main/resources/liquibase/data/demands.csv'
first_demands_data = list(parse_first_demands(first_demands_path))

def print_output(): # to test parsing, run it forwarding the output to a file
    print(f"Parsed connections: {len(connections_data)}")
    for i, connection in enumerate(connections_data):
        print(f"Connection {i}: {connection}")

    print(f"Parsed customers: {len(customers_data)}")
    for i, customer in enumerate(customers_data):
        print(f"Customer {i}: {customer}")

    print(f"Parsed refineries: {len(refineries_data)}")
    for i, refinery in enumerate(refineries_data):
        print(f"Refinery {i}: {refinery}")

    print(f"Parsed tanks: {len(tanks_data)}")
    for i, tank in enumerate(tanks_data):
        print(f"Tank {i}: {tank}")

    print(f"Parsed first demands: {len(first_demands_data)}")
    for i, demand in enumerate(first_demands_data):
        print(f"Demand {i}: {demand}")

def make_id_to_obj_dict():
    id_to_obj = {}
    for connection in connections_data:
        id_to_obj[connection.connection_id] = connection
    for customer in customers_data:
        id_to_obj[customer.customer_id] = customer
    for refinery in refineries_data:
        id_to_obj[refinery.refinery_id] = refinery
    for tank in tanks_data:
        id_to_obj[tank.tank_id] = tank
    return id_to_obj

    


        
