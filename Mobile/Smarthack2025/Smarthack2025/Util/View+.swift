//
//  View+.swift
//  Smarthack2025
//
//  Created by Alexia Aldea on 30.10.2024.
//

import SwiftUI

extension View {
    func border(_ color: Color, width: CGFloat, cornerRadius: CGFloat) -> some View {
        overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: width))
    }
    
    func borderWithShadow(borderColor: Color, width: CGFloat, cornerRadius: CGFloat, fillColor: Color, shadowColor: Color, shadowRadius: CGFloat, x: CGFloat, y: CGFloat) -> some View {
        background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(fillColor)
                .shadow(color: shadowColor, radius: shadowRadius, x: x, y: y))
        .border(borderColor, width: width, cornerRadius: cornerRadius)
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct NodePosition: Equatable {
    let id: String
    let point: Anchor<CGPoint>
}

struct NodePositionKey: PreferenceKey {
    static var defaultValue: [NodePosition] = []

    static func reduce(value: inout [NodePosition], nextValue: () -> [NodePosition]) {
        value.append(contentsOf: nextValue())
    }
}

extension View {
    func drawConnections(connections: [Connection]) -> some View {
        self.overlayPreferenceValue(NodePositionKey.self) { nodePositions in
            GeometryReader { geometry in
                ForEach(connections, id: \.id) { connection in
                    if let fromPosition = nodePositions.first(where: { $0.id == connection.fromId }),
                       let toPosition = nodePositions.first(where: { $0.id == connection.toId }) {
//                        Button {
//                            action(connection)
//                        } label: {
                            Path { path in
                                let fromPoint = geometry[fromPosition.point]
                                let toPoint = geometry[toPosition.point]
                                path.move(to: fromPoint)
                                path.addLine(to: toPoint)
                            }
                            .stroke(
                                connection.isCurrentlyUsed ? Color.occupiedPath : Color.freePath,
                                lineWidth: 2
                            )
//                        }
                    }
                }
            }
        }
    }
}
