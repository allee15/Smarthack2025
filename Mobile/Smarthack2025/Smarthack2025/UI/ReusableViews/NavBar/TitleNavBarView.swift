//
//  TitleNavBarView.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 30.10.2024.
//

import SwiftUI

struct TitleNavBarView: View {
    let title: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .foregroundColor(.black)
                .font(.poppinsBold(size: 20))
                
            Spacer()
        }
    }
}
