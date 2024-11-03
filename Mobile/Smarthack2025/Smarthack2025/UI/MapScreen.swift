//
//  ContentView.swift
//  Smarthack2025
//
//  Created by Aldea Alexia on 30.10.2024.
//

import SwiftUI

struct MapScreen: View {
    @EnvironmentObject private var navigation: Navigation
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        HStack {
            Spacer()
            ScrollView([.vertical, .horizontal], showsIndicators: false) {
                VStack(spacing: 36) {
                    Spacer()
                    switch viewModel.refineriesState {
                    case .loading:
                        LoaderView()
                    case .failure(_):
                        Text("Refineries error")
                            .font(.poppinsBold(size: 20))
                            .foregroundStyle(Color.refinery)
                        
                    case .value(let refineries):
                        RefineriesView(refineries: refineries)
                        
                        switch viewModel.tankState {
                        case .loading:
                            LoaderView()
                        case .failure(_):
                            Text("Tanks error")
                                .font(.poppinsBold(size: 20))
                                .foregroundStyle(Color.refinery)
                            
                        case .value(let tanks):
                            StorageTanksView(tanks: tanks)
                                .padding(.bottom, 600)
                            
                            switch viewModel.customerState {
                            case .loading:
                                LoaderView()
                            case .failure(_):
                                Text("Customers error")
                                    .font(.poppinsBold(size: 20))
                                    .foregroundStyle(Color.refinery)
                                
                            case .value(let customers):
                                CustomersView(customers: customers)
                            }
                        }
                        
                    }
                    Spacer()
                }
                
            }
            Spacer()
        }.ignoresSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .drawConnections(connectionsState: viewModel.connectionState)
            .onAppear {
                viewModel.connectWebSocket()
            }
            .onDisappear {
                viewModel.disconnectWebSocket()
            }
    }
}

struct RefineriesView: View {
    @EnvironmentObject private var navigation: Navigation
    let refineries: [Refinery]
    
    var body: some View {
        VStack(spacing: 32) {
            Text("REFINERIES")
                .font(.poppinsSemiBold(size: 20))
                .foregroundStyle(Color.refinery)
            
            HStack(spacing: 20) {
                ForEach(refineries, id: \.id) { refinery in
                    NodeView(name: refinery.name, color: Color.refinery) {
                        let view = ModalInfoRefineryView(refinery: refinery) {
                            navigation.dismissModal(animated: true, completion: nil)
                        }
                        navigation.presentPopup(view.asDestination(), animated: true, completion: nil)
                    }.anchorPreference(key: NodePositionKey.self, value: .bottom) {
                        [NodePosition(id: refinery.id, point: $0)]
                    }
                }
            }
        }
    }
}

struct StorageTanksView: View {
    @EnvironmentObject private var navigation: Navigation
    let tanks: [Tank]
    
    var body: some View {
        VStack(spacing: 32) {
            Text("STORAGE TANKS")
                .font(.poppinsSemiBold(size: 20))
                .foregroundStyle(Color.tank)
            
            HStack(spacing: 400) {
                ForEach(tanks, id: \.id) { tank in
                    NodeView(name: tank.name, color: Color.tank) {
                        let view = ModalInfoTankView(tank: tank) {
                            navigation.dismissModal(animated: true, completion: nil)
                        }
                        navigation.presentPopup(view.asDestination(), animated: true, completion: nil)
                    }.anchorPreference(key: NodePositionKey.self, value: .bottom) {
                        [NodePosition(id: tank.id, point: $0)]
                    }
                }
            }
        }
    }
}

struct CustomersView: View {
    @EnvironmentObject private var navigation: Navigation
    let customers: [Customer]
    
    var body: some View {
        VStack(spacing: 32) {
            Text("CUSTOMERS")
                .font(.poppinsSemiBold(size: 20))
                .foregroundStyle(Color.customer)
            
            HStack(spacing: 20) {
                ForEach(customers, id: \.id) { customer in
                    NodeView(name: customer.name, color: Color.customer) {
                        let view = ModalInfoCustomerView(customer: customer) {
                            navigation.dismissModal(animated: true, completion: nil)
                        }
                        navigation.presentPopup(view.asDestination(), animated: true, completion: nil)
                    }.anchorPreference(key: NodePositionKey.self, value: .top) {
                        [NodePosition(id: customer.id, point: $0)]
                    }
                }
            }
        }
    }
}

struct NodeView: View {
    let name: String
    let color: Color
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(name)
                .font(.poppinsRegular(size: 14))
                .foregroundStyle(Color.black)
                .padding(.all, 20)
                .background(color.opacity(0.3))
                .border(color, width: 2, cornerRadius: 4)
        }
    }
}

struct ModalInfoRefineryView: View {
    let refinery: Refinery
    let action: () -> ()
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 16) {
                    Text(refinery.name)
                        .font(.poppinsBold(size: 20))
                        .foregroundStyle(Color.refinery)
                    
                    HStack(spacing: 40) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Capacity: \(refinery.capacity)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.refinery.opacity(0.6))
                            
                            Text("Maximum output: \(refinery.maxOutput)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.refinery.opacity(0.6))
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Production: \(refinery.production)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.refinery.opacity(0.6))
                            
                            Text("Overflow penalty: \(refinery.overflowPenalty)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.refinery.opacity(0.6))
                        }
                    }
                    
                    HStack(spacing: 40) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Underflow penalty: \(refinery.underflowPenalty)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.refinery.opacity(0.6))
                            
                            Text("Over output penalty: \(refinery.overOutputPenalty)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.refinery.opacity(0.6))
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Production cost: \(refinery.productionCost)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.refinery.opacity(0.6))
                            
                            Text("Production CO2: \(refinery.productionCo2)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.refinery.opacity(0.6))
                        }
                    }
                    
                    HStack(spacing: 40) {
                        Text("Initial stock: \(refinery.initialStock)")
                            .font(.poppinsBold(size: 14))
                            .foregroundStyle(Color.refinery.opacity(0.6))
                        
                        Text("Initial stock: \(refinery.initialStock)")
                            .font(.poppinsBold(size: 14))
                            .foregroundStyle(Color.refinery.opacity(0.6))
                            .opacity(0)
                    }
                    
                    Button {
                        action()
                    } label: {
                        Text("Close")
                            .font(.poppinsRegular(size: 14))
                            .foregroundStyle(Color.black)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 32)
                            .background(Color.gray.opacity(0.5))
                            .border(Color.gray.opacity(0.5), width: 2, cornerRadius: 4)
                    }
                }.padding(.all, 20)
                    .background(Color.white)
                    .border(Color.white, width: 2, cornerRadius: 4)
                
                Spacer()
            }
            Spacer()
        }.background(Color.black.opacity(0.5))
    }
}

struct ModalInfoTankView: View {
    let tank: Tank
    let action: () -> ()
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 16) {
                    Text(tank.name)
                        .font(.poppinsBold(size: 20))
                        .foregroundStyle(Color.tank)
                    
                    HStack(spacing: 40) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Capacity: \(tank.capacity)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.tank.opacity(0.5))
                            
                            Text("Initial stock: \(tank.initialStock)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.tank.opacity(0.5))
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Maximum input: \(tank.maxInput)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.tank.opacity(0.5))
                            
                            Text("Maximum output: \(tank.maxOutput)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.tank.opacity(0.5))
                        }
                    }
                    
                    HStack(spacing: 40) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Underflow penalty: \(tank.underflowPenalty)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.tank.opacity(0.5))
                            
                            Text("Overflow penalty: \(tank.overflowPenalty)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.tank.opacity(0.5))
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Over input penalty: \(tank.overInputPenalty)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.tank.opacity(0.5))
                            
                            Text("Over output penalty: \(tank.overOutputPenalty)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.tank.opacity(0.5))
                        }
                    }
                    
                    Button {
                        action()
                    } label: {
                        Text("Close")
                            .font(.poppinsRegular(size: 14))
                            .foregroundStyle(Color.black)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 32)
                            .background(Color.gray.opacity(0.5))
                            .border(Color.gray.opacity(0.5), width: 2, cornerRadius: 4)
                    }
                }.padding(.all, 20)
                    .background(Color.white)
                    .border(Color.white, width: 2, cornerRadius: 4)
                
                Spacer()
            }
            Spacer()
        }.background(Color.black.opacity(0.5))
    }
}

struct ModalInfoCustomerView: View {
    let customer: Customer
    let action: () -> ()
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 16) {
                    Text(customer.name)
                        .font(.poppinsBold(size: 20))
                        .foregroundStyle(Color.customer)
                    
                    HStack(spacing: 40) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Maximum input: \(customer.maxInput)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.customer.opacity(0.5))
                            
                            Text("Over input penalty: \(customer.overInputPenalty)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.customer.opacity(0.5))
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Early delivery penalty: \(customer.earlyDeliveryPenalty)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.customer.opacity(0.5))
                            
                            Text("Late delivery penalty: \(customer.lateDeliveryPenalty)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(Color.customer.opacity(0.5))
                        }
                    }
                    
                    Button {
                        action()
                    } label: {
                        Text("Close")
                            .font(.poppinsRegular(size: 14))
                            .foregroundStyle(Color.black)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 32)
                            .background(Color.gray.opacity(0.5))
                            .border(Color.gray.opacity(0.5), width: 2, cornerRadius: 4)
                    }
                }.padding(.all, 20)
                    .background(Color.white)
                    .border(Color.white, width: 2, cornerRadius: 4)
                
                Spacer()
            }
            Spacer()
        }.background(Color.black.opacity(0.5))
    }
}

struct ModalInfoConnectionView: View {
    let connection: Connection
    let action: () -> ()
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                Spacer()
                VStack(alignment: .leading, spacing: 16) {
                    Text("Connection")
                        .font(.poppinsBold(size: 20))
                        .foregroundStyle(Color.black)
                    
                    HStack(spacing: 40) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("From id: \(connection.fromId)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(connection.isCurrentlyUsed ? Color.occupiedPath : Color.freePath)
                            
                            Text("To id: \(connection.toId)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(connection.isCurrentlyUsed ? Color.occupiedPath : Color.freePath)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Distance: \(connection.distance)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(connection.isCurrentlyUsed ? Color.occupiedPath : Color.freePath)
                            
                            Text("Lead time days: \(connection.leadTimeDays)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(connection.isCurrentlyUsed ? Color.occupiedPath : Color.freePath)
                        }
                    }
                    
                    HStack(spacing: 40) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Maximum capacity: \(connection.maxCapacity)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(connection.isCurrentlyUsed ? Color.occupiedPath : Color.freePath)
                            
                            Text("Connection type: \(connection.connectionType)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(connection.isCurrentlyUsed ? Color.occupiedPath : Color.freePath)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Distance: \(connection.distance)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(connection.isCurrentlyUsed ? Color.occupiedPath : Color.freePath)
                            
                            Text("Lead time days: \(connection.leadTimeDays)")
                                .font(.poppinsBold(size: 14))
                                .foregroundStyle(connection.isCurrentlyUsed ? Color.occupiedPath : Color.freePath)
                        }.opacity(0)
                    }
                    
                    Button {
                        action()
                    } label: {
                        Text("Close")
                            .font(.poppinsRegular(size: 14))
                            .foregroundStyle(Color.black)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 32)
                            .background(Color.gray.opacity(0.5))
                            .border(Color.gray.opacity(0.5), width: 2, cornerRadius: 4)
                    }
                }.padding(.all, 20)
                    .background(Color.white)
                    .border(Color.white, width: 2, cornerRadius: 4)
                
                Spacer()
            }
            Spacer()
        }.background(Color.black.opacity(0.5))
    }
}
