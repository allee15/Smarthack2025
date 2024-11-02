//
//  Tank.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 02.11.2024.
//

import Foundation

struct Tank {
    let id: String
    let name: String
    let capacity: Int64
    let maxInput: Int64
    let maxOutput: Int64
    let overflowPenalty: Double
    let underflowPenalty: Double
    let overInputPenalty: Double
    let overOutputPenalty: Double
    let initialStock: Int64
    let nodeType: String
}

let tanks: [Tank] = [
    Tank(id: "tank1", name: "Tank A", capacity: 50000, maxInput: 1000, maxOutput: 800, overflowPenalty: 1.5, underflowPenalty: 1.2, overInputPenalty: 2.0, overOutputPenalty: 2.2, initialStock: 25000, nodeType: "TANK"),
    Tank(id: "tank2", name: "Tank B", capacity: 60000, maxInput: 1200, maxOutput: 1000, overflowPenalty: 1.8, underflowPenalty: 1.3, overInputPenalty: 2.1, overOutputPenalty: 2.4, initialStock: 30000, nodeType: "TANK"),
    Tank(id: "tank3", name: "Tank C", capacity: 75000, maxInput: 1500, maxOutput: 1200, overflowPenalty: 1.9, underflowPenalty: 1.5, overInputPenalty: 2.5, overOutputPenalty: 2.7, initialStock: 40000, nodeType: "TANK"),
    Tank(id: "tank4", name: "Tank D", capacity: 85000, maxInput: 1800, maxOutput: 1300, overflowPenalty: 2.0, underflowPenalty: 1.6, overInputPenalty: 2.8, overOutputPenalty: 2.9, initialStock: 50000, nodeType: "TANK")
]

