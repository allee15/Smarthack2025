//
//  Refineries.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 02.11.2024.
//

import Foundation

struct Refinery {
    let id: String
    let name: String
    let capacity: Int64
    let maxOutput: Int64
    let production: Int64
    let overflowPenalty: Double
    let underflowPenalty: Double
    let overOutputPenalty: Double
    let productionCost: Double
    let productionCo2: Double
    let initialStock: Int64
    let nodeType: String
}

let refineries: [Refinery] = [
    Refinery(id: "refinery1", name: "Refinery Alpha", capacity: 200000, maxOutput: 5000, production: 4500, overflowPenalty: 2.5, underflowPenalty: 1.8, overOutputPenalty: 2.9, productionCost: 3.2, productionCo2: 6.0, initialStock: 100000, nodeType: "REFINERY"),
    Refinery(id: "refinery2", name: "Refinery Beta", capacity: 250000, maxOutput: 6000, production: 5500, overflowPenalty: 2.8, underflowPenalty: 2.0, overOutputPenalty: 3.1, productionCost: 3.5, productionCo2: 6.5, initialStock: 120000, nodeType: "REFINERY"),
    Refinery(id: "refinery3", name: "Refinery Gamma", capacity: 300000, maxOutput: 7000, production: 6500, overflowPenalty: 3.0, underflowPenalty: 2.3, overOutputPenalty: 3.5, productionCost: 3.8, productionCo2: 7.0, initialStock: 150000, nodeType: "REFINERY"),
    Refinery(id: "refinery4", name: "Refinery Delta", capacity: 350000, maxOutput: 7500, production: 7000, overflowPenalty: 3.2, underflowPenalty: 2.5, overOutputPenalty: 3.8, productionCost: 4.0, productionCo2: 7.5, initialStock: 180000, nodeType: "REFINERY")
]

