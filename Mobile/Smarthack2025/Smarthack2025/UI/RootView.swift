//
//  RootView.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 30.10.2024.
//

import SwiftUI
import Network
import Combine

enum RootViewModelEvent {
    case goToTabBar
    case goToLogin
    case goToOnboarding
}

class RootViewModel: BaseViewModel {
    let eventSubject = PassthroughSubject<RootViewModelEvent, Never>()
    var userDefaultsService = UserDefaultsService.shared
    
    private var binded = false
    
    @Published var showBlockingError: Bool = false
    @Published var isLoadingBinding: Bool = false
    
    func bind() {
        showBlockingError = false
        
        guard !binded else {return}
        binded = true
        
        if userDefaultsService.getOnboardingStatus() {
            self.eventSubject.send(.goToLogin)
        } else {
            self.eventSubject.send(.goToOnboarding)
        }
//        loadSubject(publisher: userService.userReactiveData.getStateSubject()) { [weak self] state in
//            guard let self else {return}
//            switch state {
//            case .failure:
//                self.isLoadingBinding = false
//                self.showBlockingError = true
//                self.binded = false
//            case .loading:
//                self.isLoadingBinding = true
//            case .ready(let userState):
//                self.isLoadingBinding = false
//                self.showBlockingError = false
//                switch userState {
//                case .anonymous:
//                    if self.propertyStorage.getOnboardingStatus() {
//                        self.emitEvent(.goToTabBar)
//                    } else {
//                        self.emitEvent(.goToOnboarding)
//                    }
//                case .loggedIn(_):
//                    if case .anonymous = self.lastUserState {
//                        self.emitEvent(.goToTabBar)
//                    }
//                }
//
//                self.lastUserState = userState
//            }
//        }
    }
    
    func retryBinding() {
        showBlockingError = false
        isLoadingBinding = true
        
        bind()
    }
}

struct RootView: View {
    private let mainNavigation = EnvironmentObjects.navigation
    let navigation: Navigation
    
    @StateObject private var viewModel = RootViewModel()
    
    var body: some View {
        ControllerRepresentable(controller: navigation.navigationController)
            .ignoresSafeArea()
            .onReceive(viewModel.eventSubject, perform: { event in
                switch event {
                case .goToTabBar:
                    TabBarCoordinator.instance.tabBarNavigation = .home
                    navigation.replaceNavigationStack([TabBarScreen().asDestination()], animated: true)
                case .goToLogin:
                    TabBarCoordinator.instance.tabBarNavigation = .home
                    navigation.replaceNavigationStack([TabBarScreen().asDestination()], animated: true)
//                    navigation.replaceNavigationStack([LoginScreen().asDestination(tag: "login")], animated: true)
                case .goToOnboarding:
                    navigation.push(OnboardingScreen().asDestination(), animated: true)
                }
            }).onAppear {
                viewModel.bind()
            }
    }
}
