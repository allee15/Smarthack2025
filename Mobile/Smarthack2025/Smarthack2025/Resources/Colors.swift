//
//  Colors.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 30.10.2024.
//

import Foundation
import SwiftUI

extension Color {
    static let refinery = Color(hex: "#98B5E3")
    static let tank = Color(hex: "#41593D")
    static let customer = Color(hex: "#A1829E")
    static let freePath = Color(hex: "#88D1B0")
    static let occupiedPath = Color(hex: "#7D2F56")
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            self.init(red: 0, green: 0, blue: 0, opacity: 0)
            return
        }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            self.init(red: 0, green: 0, blue: 0, opacity: 0)
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

