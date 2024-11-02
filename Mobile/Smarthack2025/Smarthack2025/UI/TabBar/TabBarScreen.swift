//
//  TabBarScreen.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 30.10.2024.
//

import SwiftUI

enum TabBarNavigation {
    case home
    case search
    case chats
    case profile
    case coins
}

class TabBarCoordinator: ObservableObject {
    static let instance = TabBarCoordinator()
    @Published var tabBarNavigation: TabBarNavigation?
    @Published var showTabBar: Bool = true
}

//struct TabBarScreen: View {
//    @EnvironmentObject private var navigation: Navigation
//
//    @ObservedObject private var tabBarCoordinator = TabBarCoordinator.instance
//    @StateObject private var viewModel = TabBarViewModel()
//    
//    @StateObject private var homeNavigation = Navigation(root: MapScreen().asDestination())
//    @StateObject private var searchNavigation = Navigation(root: MapScreen().asDestination())
//    @StateObject private var chatsNavigation = Navigation(root: MapScreen().asDestination())
//    @StateObject private var profileNavigation = Navigation(root: MapScreen().asDestination())
//    @StateObject private var coinsNavigation = Navigation(root: MapScreen().asDestination())
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            GeometryReader { proxy in
//                LazyHStack(spacing: 0) {
//                    Group {
//                        switch viewModel.selectedTabItem {
//                        case .home:
//                            NavigationHostView(navigation: homeNavigation)
//                        case .search:
//                            NavigationHostView(navigation: searchNavigation)
//                        case .chats:
//                            NavigationHostView(navigation: chatsNavigation)
//                        case .profile:
//                            NavigationHostView(navigation: profileNavigation)
//                        case .coins:
//                            NavigationHostView(navigation: coinsNavigation)
//                        }
//                    }.frame(width: proxy.size.width, height: proxy.size.height)
//                }.onReceive(viewModel.$selectedTabItem) { newValue in
//                    homeNavigation.popToRoot(animated: false)
//                    searchNavigation.popToRoot(animated: false)
//                    chatsNavigation.popToRoot(animated: false)
//                    profileNavigation.popToRoot(animated: false)
//                    coinsNavigation.popToRoot(animated: false)
//                    self.viewModel.oldSelectedTab = newValue
//                }.onReceive(tabBarCoordinator.$tabBarNavigation, perform: { value in
//                    if let value {
//                        switch value {
//                        case .home:
//                            if viewModel.selectedTabItem != .home {
//                                viewModel.selectedTabItem = .home
//                            }
//                            homeNavigation.popToRoot(animated: true)
//                        case .search:
//                            if viewModel.selectedTabItem != .search {
//                                viewModel.selectedTabItem = .search
//                            }
//                            searchNavigation.popToRoot(animated: true)
//                        case .chats:
//                            if viewModel.selectedTabItem != .chats {
//                                viewModel.selectedTabItem = .chats
//                            }
//                            chatsNavigation.popToRoot(animated: true)
//                        case .profile:
//                            if viewModel.selectedTabItem != .profile {
//                                viewModel.selectedTabItem = .profile
//                            }
//                            profileNavigation.popToRoot(animated: true)
//                        case .coins:
//                            if viewModel.selectedTabItem != .coins {
//                                viewModel.selectedTabItem = .coins
//                            }
//                            coinsNavigation.popToRoot(animated: true)
//                        }
//                    }
//                })
//            }.frame(maxWidth: .infinity, maxHeight: .infinity)
//            
//            if tabBarCoordinator.showTabBar {
//                TabBarView(
//                    selectedItem: $viewModel.selectedTabItem,
//                    items: viewModel.tabBarItems
//                )
//            }
//            
//        }.frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color.white)
//            .ignoresSafeArea(.container)
//            .ignoresSafeArea(.keyboard)
//            .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 0)
//    }
//}
