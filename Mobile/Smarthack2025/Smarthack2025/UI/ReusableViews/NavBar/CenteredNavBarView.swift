//
//  RightNavBar.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 30.10.2024.
//

import SwiftUI

struct CenteredNavBarView: View {
    let icon: ImageResource
    let title: String
    let action: () -> ()
    
    var body: some View {
        HStack {
            
            Spacer()
            
            TitleNavBarView(title: title)
            
            Spacer()
            
        }.padding([.horizontal, .bottom], 16)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.3), radius: 1, x: 0, y: 0)
            .zIndex(1)
    }
}
