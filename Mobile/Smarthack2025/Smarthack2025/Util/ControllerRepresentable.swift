//
//  ControllerRepresentable.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 30.10.2024.
//

import UIKit
import SwiftUI

struct ControllerRepresentable: UIViewControllerRepresentable {
    let controller: UIViewController
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}

