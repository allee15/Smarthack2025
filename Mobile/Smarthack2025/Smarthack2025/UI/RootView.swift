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
}

class RootViewModel: BaseViewModel {
    let eventSubject = PassthroughSubject<RootViewModelEvent, Never>()
    
    private var binded = false
    
    @Published var showBlockingError: Bool = false
    
    func bind() {
        showBlockingError = false
        
        guard !binded else {return}
        binded = true
        
        self.eventSubject.send(.goToTabBar)
    }
    
    func retryBinding() {
        showBlockingError = false
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
                    navigation.replaceNavigationStack([MapScreen().asDestination()], animated: true)
                }
            }).onAppear {
                viewModel.bind()
            }
    }
}
