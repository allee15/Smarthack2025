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
    let distance: String
    let leadTimeDays: String
    let connectionType: String
    let maxCapacity: String
    var isCurrentlyUsed: Bool
}

