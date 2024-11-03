import flask
from flask import request, jsonify
from parser import *
from classes import *

app = flask.Flask(__name__)

basePath = '/Users/allee/Documents/hackatoane/Smarthack2024/eval-platform/src/main/resources/liquibase/data/'

@app.route('/connections', methods=['GET'])
def get_connections():
    connections_path = basePath + 'connections.csv'
    connections_data = list(parse_connections(connections_path))
    return jsonify([connection.to_dict() for connection in connections_data])

@app.route('/customers', methods=['GET'])
def get_customers():
    customers_path = basePath + 'customers.csv'
    customers_data = list(parse_customers(customers_path))
    return jsonify([customer.to_dict() for customer in customers_data])

@app.route('/refineries', methods=['GET'])
def get_refineries():
    refineries_path = basePath + 'refineries.csv'
    refineries_data = list(parse_refineries(refineries_path))
    return jsonify([refinery.to_dict() for refinery in refineries_data])

@app.route('/tanks', methods=['GET'])
def get_tanks():
    tanks_path = basePath + 'tanks.csv'
    tanks_data = list(parse_tanks(tanks_path))
    return jsonify([tank.to_dict() for tank in tanks_data])

if __name__ == '__main__':
    app.run(debug=True)                
