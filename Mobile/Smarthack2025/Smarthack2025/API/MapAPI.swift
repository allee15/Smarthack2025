//
//  MapAPI.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 02.11.2024.
//

import Foundation
import Combine
import SwiftyJSON

let basePath = "http://127.0.0.1:5000/"

class MapAPI: ObservableObject {
    @Published var refineries = [Refinery]()
    var refineriesPublisher = PassthroughSubject<[Refinery], Never>()
    @Published var tanks = [Tank]()
    var tanksPublisher = PassthroughSubject<[Tank], Never>()
    @Published var customers = [Customer]()
    var customersPublisher = PassthroughSubject<[Customer], Never>()
    @Published var connections = [Connection]()
    var connectionsPublisher = PassthroughSubject<[Connection], Never>()
    
    private let webSocketURL = URL(string: "ws://127.0.0.1:5000/updates") // Adjust to your server’s WebSocket URL
    private var webSocketTask: URLSessionWebSocketTask?
    private var cancellables = Set<AnyCancellable>()
    
    func getRefineries() -> Future<[Refinery], Error> {
        Future { promise in
            var urlComponents = URLComponents(string: "\(basePath)refineries")
            
            urlComponents?.queryItems = []
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        var arrayToReturn = [Refinery]()
                        let json = try JSON(data: data!)
                        let refineries = json.arrayValue
                        for item in refineries {
                            let refinery = Refinery(id: item["refinery_id"].stringValue,
                                                    name: item["name"].stringValue,
                                                    capacity: item["capacity"].stringValue,
                                                    maxOutput: item["max_output"].stringValue,
                                                    production: item["production"].stringValue,
                                                    overflowPenalty: item["overflow_penalty"].stringValue,
                                                    underflowPenalty: item["underflow_penalty"].stringValue,
                                                    overOutputPenalty: item["over_output_penalty"].stringValue,
                                                    productionCost: item["production_cost"].stringValue,
                                                    productionCo2: item["production_co2"].stringValue,
                                                    initialStock: item["initial_stock"].stringValue,
                                                    nodeType: item["node_type"].stringValue)
                            arrayToReturn.append(refinery)
                        }
                        promise(.success(arrayToReturn))
                        
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func getCustomers() -> Future<[Customer], Error> {
        Future { promise in
            var urlComponents = URLComponents(string: "\(basePath)customers")
            
            urlComponents?.queryItems = []
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        var arrayToReturn = [Customer]()
                        let json = try JSON(data: data!)
                        let customers = json.arrayValue
                        for item in customers {
                            
                            let customer = Customer(id: item["customer_id"].stringValue,
                                                    name: item["name"].stringValue,
                                                    maxInput: item["max_input"].stringValue,
                                                    overInputPenalty: item["over_input_penalty"].stringValue,
                                                    lateDeliveryPenalty: item["late_delivery_penalty"].stringValue,
                                                    earlyDeliveryPenalty: item["early_delivery_penalty"].stringValue,
                                                    nodeType: item["node_type"].stringValue)
                            arrayToReturn.append(customer)
                        }
                        promise(.success(arrayToReturn))
                        
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func getConnections() -> Future<[Connection], Error> {
        Future { promise in
            var urlComponents = URLComponents(string: "\(basePath)connections")
            
            urlComponents?.queryItems = []
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        var arrayToReturn = [Connection]()
                        let json = try JSON(data: data!)
                        let connections = json.arrayValue
                        for item in connections {
                            
                            let connection = Connection(id: item["connection_id"].stringValue,
                                                        fromId: item["from_id"].stringValue,
                                                        toId: item["to_id"].stringValue,
                                                        distance: item["distance"].stringValue,
                                                        leadTimeDays: item["lead_time_days"].stringValue,
                                                        connectionType: item["connection_type"].stringValue,
                                                        maxCapacity: item["max_capacity"].stringValue,
                                                        isCurrentlyUsed: Bool.random()) //todo fix me
                            arrayToReturn.append(connection)
                        }
                        promise(.success(arrayToReturn))
                        
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func getTanks() -> Future<[Tank], Error> {
        Future { promise in
            var urlComponents = URLComponents(string: "\(basePath)tanks")
            
            urlComponents?.queryItems = []
            
            var urlRequest = URLRequest(url: (urlComponents?.url)!)
            
            urlRequest.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        var arrayToReturn = [Tank]()
                        let json = try JSON(data: data!)
                        let tanks = json.arrayValue
                        for item in tanks {
                            
                            let tank = Tank(id: item["tank_id"].stringValue,
                                            name: item["name"].stringValue,
                                            capacity: item["capacity"].stringValue,
                                            maxInput: item["max_input"].stringValue,
                                            maxOutput: item["max_output"].stringValue,
                                            overflowPenalty: item["overflow_penalty"].stringValue,
                                            underflowPenalty: item["underflow_penalty"].stringValue,
                                            overInputPenalty: item["over_input_penalty"].stringValue,
                                            overOutputPenalty: item["over_output_penalty"].stringValue,
                                            initialStock: item["initial_stock"].stringValue,
                                            nodeType: item["node_type"].stringValue)
                            arrayToReturn.append(tank)
                        }
                        promise(.success(arrayToReturn))
                        
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func connectWebSocket() {
        guard let url = webSocketURL else { return }
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessages()
    }
    
    // Listen for messages
    private func receiveMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket error: \(error)")
            case .success(let message):
                self?.handleWebSocketMessage(message)
                self?.receiveMessages() // Continue listening for new messages
            }
        }
    }
    
    // Handle received messages
    private func handleWebSocketMessage(_ message: URLSessionWebSocketTask.Message) {
        switch message {
        case .string(let jsonString):
            handleJSONMessage(jsonString)
        case .data(let data):
            if let jsonString = String(data: data, encoding: .utf8) {
                handleJSONMessage(jsonString)
            }
        default:
            break
        }
    }
    
    private func handleJSONMessage(_ jsonString: String) {
        guard let data = jsonString.data(using: .utf8) else { return }
        let json = try? JSON(data: data)
        
        if let refineries = json?["refineries"].array {
            let updatedRefineries = refineries.map { item -> Refinery in
                return Refinery(
                    id: item["refinery_id"].stringValue,
                    name: item["name"].stringValue,
                    capacity: item["capacity"].stringValue,
                    maxOutput: item["max_output"].stringValue,
                    production: item["production"].stringValue,
                    overflowPenalty: item["overflow_penalty"].stringValue,
                    underflowPenalty: item["underflow_penalty"].stringValue,
                    overOutputPenalty: item["over_output_penalty"].stringValue,
                    productionCost: item["production_cost"].stringValue,
                    productionCo2: item["production_co2"].stringValue,
                    initialStock: item["initial_stock"].stringValue,
                    nodeType: item["node_type"].stringValue
                )
            }
            DispatchQueue.main.async {
                self.refineries = updatedRefineries
                self.refineriesPublisher.send(updatedRefineries) // Notify subscribers of new data
            }
        }
        
        if let connections = json?["connections"].array {
            let updatedConnections = connections.map { item -> Connection in
                return Connection(id: item["connection_id"].stringValue,
                                  fromId: item["from_id"].stringValue,
                                  toId: item["to_id"].stringValue,
                                  distance: item["distance"].stringValue,
                                  leadTimeDays: item["lead_time_days"].stringValue,
                                  connectionType: item["connection_type"].stringValue,
                                  maxCapacity: item["max_capacity"].stringValue,
                                  isCurrentlyUsed: Bool.random())
            }
            DispatchQueue.main.async {
                self.connections = updatedConnections
                self.connectionsPublisher.send(updatedConnections)
            }
        }
        
        if let customers = json?["customers"].array {
            let updatedCustomers = customers.map { item -> Customer in
                return Customer(id: item["customer_id"].stringValue,
                                name: item["name"].stringValue,
                                maxInput: item["max_input"].stringValue,
                                overInputPenalty: item["over_input_penalty"].stringValue,
                                lateDeliveryPenalty: item["late_delivery_penalty"].stringValue,
                                earlyDeliveryPenalty: item["early_delivery_penalty"].stringValue,
                                nodeType: item["node_type"].stringValue)
            }
            DispatchQueue.main.async {
                self.customers = updatedCustomers
                self.customersPublisher.send(updatedCustomers)
            }
        }
        
        if let tanks = json?["tanks"].array {
            let updatedTanks = tanks.map { item -> Tank in
                return Tank(id: item["tank_id"].stringValue,
                           name: item["name"].stringValue,
                           capacity: item["capacity"].stringValue,
                           maxInput: item["max_input"].stringValue,
                           maxOutput: item["max_output"].stringValue,
                           overflowPenalty: item["overflow_penalty"].stringValue,
                           underflowPenalty: item["underflow_penalty"].stringValue,
                           overInputPenalty: item["over_input_penalty"].stringValue,
                           overOutputPenalty: item["over_output_penalty"].stringValue,
                           initialStock: item["initial_stock"].stringValue,
                           nodeType: item["node_type"].stringValue)
            }
            DispatchQueue.main.async {
                self.tanks = updatedTanks
                self.tanksPublisher.send(updatedTanks)
            }
        }
    }
    
    func disconnectWebSocket() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
