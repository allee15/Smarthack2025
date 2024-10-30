//
//  BackButton.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 30.10.2024.
//

import SwiftUI

struct BackButton: View {
    @EnvironmentObject private var navigation: Navigation
    var action: (()->())?
    
    var body: some View {
        Button {
            if let action = action {
                action()
            } else {
                navigation.pop(animated: true)
            }
        } label: {
            Image(.icNavUp)
                .resizable()
                .frame(width: 32, height: 32)
        }
    }
}
