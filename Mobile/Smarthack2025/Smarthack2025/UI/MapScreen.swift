//
//  ContentView.swift
//  Smarthack2025
//
//  Created by Aldea Alexia on 30.10.2024.
//

import SwiftUI

struct MapScreen: View {
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 36) {
                Spacer()
                RefineriesView()
                StorageTanksView()
                CustomersView()
                Spacer()
            }
            Spacer()
        }.ignoresSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .drawConnections(connections: connections)
    }
}

struct RefineriesView: View {
    var body: some View {
        VStack(spacing: 32) {
            Text("REFINERIES")
                .font(.poppinsSemiBold(size: 20))
                .foregroundStyle(Color.green)
            
            HStack(spacing: 20) {
                ForEach(refineries, id: \.id) { refinery in
                    NodeView(name: refinery.name)
                        .anchorPreference(key: NodePositionKey.self, value: .center) {
                            [NodePosition(id: refinery.id, point: $0)]
                        }
                }
            }
        }
    }
}

struct StorageTanksView: View {
    var body: some View {
        VStack(spacing: 32) {
            Text("STORAGE TANKS")
                .font(.poppinsSemiBold(size: 20))
                .foregroundStyle(Color.pink)
            
            HStack(spacing: 20) {
                ForEach(tanks, id: \.id) { tank in
                    NodeView(name: tank.name)
                        .anchorPreference(key: NodePositionKey.self, value: .center) {
                            [NodePosition(id: tank.id, point: $0)]
                        }
                }
            }
        }
    }
}

struct CustomersView: View {
    var body: some View {
        VStack(spacing: 32) {
            Text("CUSTOMERS")
                .font(.poppinsSemiBold(size: 20))
                .foregroundStyle(Color.cyan)
            
            HStack(spacing: 20) {
                ForEach(customers, id: \.id) { customer in
                    NodeView(name: customer.name)
                        .anchorPreference(key: NodePositionKey.self, value: .center) {
                            [NodePosition(id: customer.id, point: $0)]
                        }
                }
            }
        }
    }
}

struct NodeView: View {
    let name: String
    
    var body: some View {
        Text(name)
            .font(.poppinsRegular(size: 14))
            .foregroundStyle(Color.black)
            .padding(.all, 20)
            .background(Color.gray.opacity(0.3))
            .border(Color.black, width: 2, cornerRadius: 4)
    }
}
