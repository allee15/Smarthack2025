class Connection:
    def __init__(self, connection_id, from_id, to_id, distance, lead_time_days, connection_type, max_capacity):
        self.connection_id = connection_id
        self.from_id = from_id
        self.to_id = to_id
        self.distance = distance
        self.lead_time_days = lead_time_days
        self.connection_type = connection_type
        self.max_capacity = max_capacity

    def __str__(self):
        return f"Connection {self.connection_id} from {self.from_id} to {self.to_id} with lead time {self.lead_time_days} days, type {self.connection_type} and max capacity {self.max_capacity}"

    def __repr__(self):
        return f"Connection({self.connection_id}, '{self.from_id}', '{self.to_id}', {self.distance}, {self.lead_time_days}, '{self.connection_type}', {self.max_capacity})"

    def to_dict(self):
        return {
            "connection_id": self.connection_id,
            "from_id": self.from_id,
            "to_id": self.to_id,
            "distance": self.distance,
            "lead_time_days": self.lead_time_days,
            "connection_type": self.connection_type,
            "max_capacity": self.max_capacity
        }

class Customer:
    def __init__(self, customer_id, name, max_input,over_input_penalty,late_delivery_penalty,early_delivery_penalty,node_type):
        self.customer_id = customer_id
        self.name = name
        self.max_input = max_input
        self.over_input_penalty = over_input_penalty
        self.late_delivery_penalty = late_delivery_penalty
        self.early_delivery_penalty = early_delivery_penalty
        self.node_type = node_type

    def __str__(self):
        return f"Customer {self.customer_id} {self.name} with max input {self.max_input}, over input penalty {self.over_input_penalty}, late delivery penalty {self.late_delivery_penalty}, early delivery penalty {self.early_delivery_penalty} and node type {self.node_type}"

    def __repr__(self):
        return f"Customer({self.customer_id}, '{self.name}', {self.max_input}, {self.over_input_penalty}, {self.late_delivery_penalty}, {self.early_delivery_penalty}, '{self.node_type}')"

    def to_dict(self):
        return {
            "customer_id": self.customer_id,
            "name": self.name,
            "max_input": self.max_input,
            "over_input_penalty": self.over_input_penalty,
            "late_delivery_penalty": self.late_delivery_penalty,
            "early_delivery_penalty": self.early_delivery_penalty,
            "node_type": self.node_type
        }

class Refinery:
    def __init__(self, refinery_id, name,capacity,max_output,production,overflow_penalty,underflow_penalty,over_output_penalty,production_cost,production_co2,initial_stock,node_type):
        self.refinery_id = refinery_id
        self.name = name
        self.capacity = capacity
        self.max_output = max_output
        self.production = production
        self.overflow_penalty = overflow_penalty
        self.underflow_penalty = underflow_penalty
        self.over_output_penalty = over_output_penalty
        self.production_cost = production_cost
        self.production_co2 = production_co2
        self.initial_stock = initial_stock
        self.node_type = node_type

    def __str__(self):
        return f"Refinery {self.refinery_id} {self.name} with capacity {self.capacity}, max output {self.max_output}, production {self.production}, overflow penalty {self.overflow_penalty}, underflow penalty {self.underflow_penalty}, over output penalty {self.over_output_penalty}, production cost {self.production_cost}, production co2 {self.production_co2}, initial stock {self.initial_stock} and node type {self.node_type}"

    def __repr__(self):
        return f"Refinery({self.refinery_id}, '{self.name}', {self.capacity}, {self.max_output}, {self.production}, {self.overflow_penalty}, {self.underflow_penalty}, {self.over_output_penalty}, {self.production_cost}, {self.production_co2}, {self.initial_stock}, '{self.node_type}')"

    def to_dict(self):
        return {
            "refinery_id": self.refinery_id,
            "name": self.name,
            "capacity": self.capacity,
            "max_output": self.max_output,
            "production": self.production,
            "overflow_penalty": self.overflow_penalty,
            "underflow_penalty": self.underflow_penalty,
            "over_output_penalty": self.over_output_penalty,
            "production_cost": self.production_cost,
            "production_co2": self.production_co2,
            "initial_stock": self.initial_stock,
            "node_type": self.node_type
        }

class Tanks:
    def __init__(self, tank_id, name,capacity,max_input,max_output,overflow_penalty,underflow_penalty,over_input_penalty,over_output_penalty,initial_stock,node_type):
        self.tank_id = tank_id
        self.name = name
        self.capacity = capacity
        self.max_input = max_input
        self.max_output = max_output
        self.overflow_penalty = overflow_penalty
        self.underflow_penalty = underflow_penalty
        self.over_input_penalty = over_input_penalty
        self.over_output_penalty = over_output_penalty
        self.initial_stock = initial_stock
        self.node_type = node_type

    def __str__(self):
        return f"Tanks {self.tank_id} {self.name} with capacity {self.capacity}, max input {self.max_input}, max output {self.max_output}, overflow penalty {self.overflow_penalty}, underflow penalty {self.underflow_penalty}, over input penalty {self.over_input_penalty}, over output penalty {self.over_output_penalty}, initial stock {self.initial_stock} and node type {self.node_type}"

    def __repr__(self):
        return f"Tanks({self.tank_id}, '{self.name}', {self.capacity}, {self.max_input}, {self.max_output}, {self.overflow_penalty}, {self.underflow_penalty}, {self.over_input_penalty}, {self.over_output_penalty}, {self.initial_stock}, '{self.node_type}')"

    def to_dict(self):
        return {
            "tank_id": self.tank_id,
            "name": self.name,
            "capacity": self.capacity,
            "max_input": self.max_input,
            "max_output": self.max_output,
            "overflow_penalty": self.overflow_penalty,
            "underflow_penalty": self.underflow_penalty,
            "over_input_penalty": self.over_input_penalty,
            "over_output_penalty": self.over_output_penalty,
            "initial_stock": self.initial_stock,
            "node_type": self.node_type
        }

class Demand:
    def __init__(self, demand_id, customer_id,quantity,post_day,start_delivery_day,end_delivery_day):
        self.demand_id = demand_id
        self.customer_id = customer_id
        self.quantity = quantity
        self.post_day = post_day
        self.start_delivery_day = start_delivery_day
        self.end_delivery_day = end_delivery_day

    def __str__(self):
        return f"Demand {self.demand_id} for customer {self.customer_id} with quantity {self.quantity}, post day {self.post_day}, start delivery day {self.start_delivery_day} and end delivery day {self.end_delivery_day}"

    def __repr__(self):
        return f"Demand({self.demand_id}, '{self.customer_id}', {self.quantity}, {self.post_day}, {self.start_delivery_day}, {self.end_delivery_day})"

    def to_dict(self):
        return {
            "demand_id": self.demand_id,
            "customer_id": self.customer_id,
            "quantity": self.quantity,
            "post_day": self.post_day,
            "start_delivery_day": self.start_delivery_day,
            "end_delivery_day": self.end_delivery_day
        }