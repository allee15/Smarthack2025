//
//  BaseViewModel.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 30.10.2024.
//

import Foundation
import Combine

class BaseViewModel: ObservableObject {
    var bag = Set<AnyCancellable>()
}
