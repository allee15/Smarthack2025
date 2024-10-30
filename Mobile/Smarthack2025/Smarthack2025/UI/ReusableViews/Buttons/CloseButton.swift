//
//  CloseButton.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 30.10.2024.
//

import SwiftUI

struct CloseButton: View {
    @EnvironmentObject private var navigation: Navigation
    var action: (() -> ())?
    
    var body: some View {
        Button {
            action?()
            navigation.replaceNavigationStack([TabBarScreen().asDestination()], animated: true)
        } label: {
            Image(.icNavClose)
                .resizable()
                .frame(width: 32, height: 32)
        }
    }
}
