//
//  MapService.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 02.11.2024.
//

import Foundation
import Combine

class MapService {
    static let shared = MapService()
    private let mapApi = MapAPI()
    private init() { }
    
    func getRefineries() -> Future<[Refinery], Error> {
        return mapApi.getRefineries()
    }
    
    func getCustomers() -> Future<[Customer], Error> {
        return mapApi.getCustomers()
    }
    
    func getConnections() -> Future<[Connection], Error> {
        return mapApi.getConnections()
    }
    
    func getTanks() -> Future<[Tank], Error> {
        return mapApi.getTanks()
    }
    
    var refineriesPublisher: AnyPublisher<[Refinery], Never> {
        mapApi.refineriesPublisher.eraseToAnyPublisher()
    }
    
    var customersPublisher: AnyPublisher<[Customer], Never> {
        mapApi.customersPublisher.eraseToAnyPublisher()
    }
    
    var connectionsPublisher: AnyPublisher<[Connection], Never> {
        mapApi.connectionsPublisher.eraseToAnyPublisher()
    }
    
    var tanksPublisher: AnyPublisher<[Tank], Never> {
        mapApi.tanksPublisher.eraseToAnyPublisher()
    }
    
    func connectWebSocket() {
        mapApi.connectWebSocket()
    }
    
    func disconnectWebSocket() {
        mapApi.disconnectWebSocket()
    }
}
