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
}
