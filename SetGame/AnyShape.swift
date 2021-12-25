//
//  SwiftUI+Extension.swift
//  SetGame
//
//  Created by Anton Kinstler on 25.12.2021.
//
import SwiftUI

struct AnyShape: Shape {
    private let builder: (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        builder = { rect in
            let path = shape.path(in: rect)
            return path
        }
    }

    func path(in rect: CGRect) -> Path {
        return builder(rect)
    }
}
