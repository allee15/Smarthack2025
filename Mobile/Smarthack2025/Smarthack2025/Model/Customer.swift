//
//  Customer.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 02.11.2024.
//

import Foundation

struct Customer {
    let id: String
    let name: String
    let maxInput: Int64
    let overInputPenalty: Double
    let lateDeliveryPenalty: Double
    let earlyDeliveryPenalty: Double
    let nodeType: String
}

let customers: [Customer] = [
    Customer(id: "customer1", name: "Customer X", maxInput: 1000, overInputPenalty: 2.0, lateDeliveryPenalty: 1.5, earlyDeliveryPenalty: 1.2, nodeType: "CUSTOMER"),
    Customer(id: "customer2", name: "Customer Y", maxInput: 1500, overInputPenalty: 2.5, lateDeliveryPenalty: 1.8, earlyDeliveryPenalty: 1.4, nodeType: "CUSTOMER"),
    Customer(id: "customer3", name: "Customer Z", maxInput: 2000, overInputPenalty: 3.0, lateDeliveryPenalty: 2.0, earlyDeliveryPenalty: 1.6, nodeType: "CUSTOMER"),
    Customer(id: "customer4", name: "Customer W", maxInput: 2500, overInputPenalty: 3.5, lateDeliveryPenalty: 2.3, earlyDeliveryPenalty: 1.8, nodeType: "CUSTOMER")
]

