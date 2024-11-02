//
//  MapViewModel.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 02.11.2024.
//

import Foundation

enum RefineryState {
    case value([Refinery])
    case failure(Error)
    case loading
}

enum CustomerState {
    case value([Customer])
    case failure(Error)
    case loading
}

enum ConnectionsState {
    case value([Connection])
    case failure(Error)
    case loading
}

enum TankState {
    case value([Tank])
    case failure(Error)
    case loading
}

class MapViewModel: BaseViewModel {
    @Published var refineriesState = RefineryState.loading
    @Published var customerState = CustomerState.loading
    @Published var connectionState = ConnectionsState.loading
    @Published var tankState = TankState.loading
    var mapService = MapService.shared
    
    override init() {
        super.init()
        loadRefineries()
        loadCustomers()
        loadConnections()
        loadTanks()
        
        subscribeToRefineryUpdates()
        subscribeToCustomerUpdates()
        subscribeToConnectionsUpdates()
        subscribeToTankUpdates()
    }
    
    func loadRefineries() {
        refineriesState = .loading
        mapService.getRefineries()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else {return}
                switch completion {
                case .failure(let error):
                    self.refineriesState = .failure(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] refineries in
                guard let self else {return}
                self.refineriesState = .value(refineries)
            } .store(in: &bag)
    }
    
    private func subscribeToRefineryUpdates() {
        mapService.refineriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] refineries in
                self?.refineriesState = .value(refineries)
            }
            .store(in: &bag)
    }
    
    func loadCustomers() {
        customerState = .loading
        mapService.getCustomers()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else {return}
                switch completion {
                case .failure(let error):
                    self.customerState = .failure(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] customers in
                guard let self else {return}
                self.customerState = .value(customers)
            } .store(in: &bag)
    }
    
    private func subscribeToCustomerUpdates() {
        mapService.customersPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] customers in
                self?.customerState = .value(customers)
            }
            .store(in: &bag)
    }
    
    func loadConnections() {
        connectionState = .loading
        mapService.getConnections()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else {return}
                switch completion {
                case .failure(let error):
                    self.connectionState = .failure(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] connections in
                guard let self else {return}
                self.connectionState = .value(connections)
            } .store(in: &bag)
    }
    
    private func subscribeToConnectionsUpdates() {
        mapService.connectionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connections in
                self?.connectionState = .value(connections)
            }
            .store(in: &bag)
    }
    
    func loadTanks() {
        tankState = .loading
        mapService.getTanks()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else {return}
                switch completion {
                case .failure(let error):
                    self.tankState = .failure(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] tanks in
                guard let self else {return}
                self.tankState = .value(tanks)
            } .store(in: &bag)
    }
    
    private func subscribeToTankUpdates() {
        mapService.tanksPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tanks in
                self?.tankState = .value(tanks)
            }
            .store(in: &bag)
    }
    
    func connectWebSocket() {
        mapService.connectWebSocket()
    }
    
    func disconnectWebSocket() {
        mapService.disconnectWebSocket()
    }
}
