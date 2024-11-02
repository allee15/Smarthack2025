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

class MapAPI {
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
}
