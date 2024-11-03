import csv
from classes import Connection, Customer, Refinery, Tanks, Demand
from api import basePath

        
class DataParser:
    def __init__(self, base_path):
        self.base_path = base_path
        self.connections_data = []
        self.customers_data = []
        self.refineries_data = []
        self.tanks_data = []
        self.first_demands_data = []
        self.id_to_obj = {}
        self.load_data()

    def load_data(self):
        self.connections_data = list(self.parse_connections(self.base_path + 'connections.csv'))
        self.customers_data = list(self.parse_customers(self.base_path + 'customers.csv'))
        self.refineries_data = list(self.parse_refineries(self.base_path + 'refineries.csv'))
        self.tanks_data = list(self.parse_tanks(self.base_path + 'tanks.csv'))
        self.first_demands_data = list(self.parse_first_demands(self.base_path + 'demands.csv'))
        self.id_to_obj = self.make_id_to_obj_dict()

    def parse_connections(self, file_path):
        with open(file_path, 'r') as file:
            csv_reader = csv.reader(file, delimiter=';', quotechar='"')
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

    def parse_customers(self, file_path):
        with open(file_path, 'r') as file:
            csv_reader = csv.reader(file, delimiter=';', quotechar='"')
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

    def parse_refineries(self, file_path):
        with open(file_path, 'r') as file:
            csv_reader = csv.reader(file, delimiter=';', quotechar='"')
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

    def parse_tanks(self, file_path):
        with open(file_path, 'r') as file:
            csv_reader = csv.reader(file, delimiter=';', quotechar='"')
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

    def parse_first_demands(self, file_path):
        with open(file_path, 'r') as file:
            csv_reader = csv.reader(file, delimiter=';', quotechar='"')
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

    def make_id_to_obj_dict(self):
        id_to_obj = {}
        for connection in self.connections_data:
            id_to_obj[connection.connection_id] = connection
        for customer in self.customers_data:
            id_to_obj[customer.customer_id] = customer
        for refinery in self.refineries_data:
            id_to_obj[refinery.refinery_id] = refinery
        for tank in self.tanks_data:
            id_to_obj[tank.tank_id] = tank
        return id_to_obj

    def print_output(self):  # to test parsing, run it forwarding the output to a file
        print(f"Parsed connections: {len(self.connections_data)}")
        for i, connection in enumerate(self.connections_data):
            print(f"Connection {i}: {connection}")

        print(f"Parsed customers: {len(self.customers_data)}")
        for i, customer in enumerate(self.customers_data):
            print(f"Customer {i}: {customer}")

        print(f"Parsed refineries: {len(self.refineries_data)}")
        for i, refinery in enumerate(self.refineries_data):
            print(f"Refinery {i}: {refinery}")

        print(f"Parsed tanks: {len(self.tanks_data)}")
        for i, tank in enumerate(self.tanks_data):
            print(f"Tank {i}: {tank}")

        print(f"Parsed first demands: {len(self.first_demands_data)}")
        for i, demand in enumerate(self.first_demands_data):
            print(f"Demand {i}: {demand}")