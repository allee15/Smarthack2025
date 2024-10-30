//
//  TabBarItem.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 30.10.2024.
//

import Foundation
import SwiftUI

enum TabBarItemType: Equatable {
    case home
    case search
    case chats
    case profile
    case coins
}

struct TabBarItem {
    let type: TabBarItemType
    let title: String
    let imageName: ImageResource
}

let homeTabBarItem = TabBarItem(
    type: .home,
    title: "Home",
    imageName: .icHome
)

let searchTabBarItem = TabBarItem(
    type: .search,
    title: "Search",
    imageName: .icHome
)

let chatsTabBarItem = TabBarItem(
    type: .chats,
    title: "Chats",
    imageName: .icHome
)

let profileNewsTabBarItem = TabBarItem(
    type: .profile,
    title: "Profile",
    imageName: .icHome
)

let coinsTabBarItem = TabBarItem(
    type: .coins,
    title: "Wallet",
    imageName: .icHome)

struct TabBarItemView: View {
    let tabBarItem: TabBarItem
    let isSelected: Bool
    let selectAction: (TabBarItem) -> ()
    
    var body: some View {
        Button {
            selectAction(tabBarItem)
        } label: {
            VStack(spacing: 4) {
                Image(tabBarItem.imageName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(isSelected ? Color.red : Color.black)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                
                Text(tabBarItem.title)
                    .font(.system(size: 12))
                    .foregroundColor(isSelected ? .red : Color.black)
                    .frame(height: 14)
            }
        }
    }
}

struct TabBarView: View {
    @Binding var selectedItem: TabBarItemType
    let items: [TabBarItem]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(items, id: \.type) { item in
                TabBarItemView(
                    tabBarItem: item,
                    isSelected: selectedItem == item.type) { tabBarItem in
                        self.selectedItem = item.type
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, SafeAreaInsets.bottom > 0 ? 0 : 4)
            }
        }.frame(maxWidth: .infinity)
            .frame(height: 46)
            .padding(.bottom, SafeAreaInsets.bottom)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .cornerRadius(8, corners: [.topLeft, .topRight])
            .background(
                Color.white
                    .cornerRadius(8, corners: [.topLeft, .topRight])
            )
            
    }
}

