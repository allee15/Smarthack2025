//
//  Connection.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 02.11.2024.
//

import Foundation

enum ConnectionType: String {
    case truck
    case pipeline
}

struct Connection {
    let id: String
    let fromId: String
    let toId: String
    let distance: Int64
    let leadTimeDays: Int64
    let connectionType: String
    let maxCapacity: Int64
}

let connections: [Connection] = [
    Connection(id: "connection1", fromId: "refinery1", toId: "tank1", distance: 234, leadTimeDays: 4, connectionType: "PIPELINE", maxCapacity: 34),
    Connection(id: "connection2", fromId: "tank1", toId: "customer1", distance: 234, leadTimeDays: 4, connectionType: "truck", maxCapacity: 34),
    Connection(id: "connection3", fromId: "refinery2", toId: "tank2", distance: 234, leadTimeDays: 4, connectionType: "PIPELINE", maxCapacity: 34),
    Connection(id: "connection4", fromId: "tank2", toId: "customer2", distance: 234, leadTimeDays: 4, connectionType: "truck", maxCapacity: 34),
    Connection(id: "connection5", fromId: "refinery3", toId: "tank3", distance: 234, leadTimeDays: 4, connectionType: "PIPELINE", maxCapacity: 34),
    Connection(id: "connection6", fromId: "tank3", toId: "customer3", distance: 234, leadTimeDays: 4, connectionType: "truck", maxCapacity: 34),
    Connection(id: "connection7", fromId: "refinery4", toId: "tank4", distance: 234, leadTimeDays: 4, connectionType: "PIPELINE", maxCapacity: 34),
    Connection(id: "connection8", fromId: "tank4", toId: "customer4", distance: 234, leadTimeDays: 4, connectionType: "truck", maxCapacity: 34)
]

