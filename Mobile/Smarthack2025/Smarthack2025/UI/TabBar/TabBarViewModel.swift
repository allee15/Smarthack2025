//
//  TabBarViewModel.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 30.10.2024.
//

import Foundation
import Combine

class TabBarViewModel: ObservableObject {
    @Published var selectedTabItem: TabBarItemType
    @Published var tabBarItems: [TabBarItem]
    
    public var oldSelectedTab: TabBarItemType
    
    init() {
        self.selectedTabItem = .home
        self.oldSelectedTab = .home
        
        tabBarItems = [
            homeTabBarItem,
            searchTabBarItem,
            chatsTabBarItem,
            profileNewsTabBarItem,
            coinsTabBarItem
        ]
    }
}

