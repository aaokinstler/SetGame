//
//  SetGameModel.swift
//  SetGame
//
//  Created by Anton Kinstler on 22.12.2021.
//

import Foundation
import SwiftUI

struct SetGameModel {
    private var deck: Array<Card>
    private(set) var cardsOnTable: Array<Card>
    private(set) var arrayOfChosenCards: Array<Int> = []
    
    var cardsInDeck: Int {
        deck.count
    }
    
    
    
    init() {
        
        deck = []
        cardsOnTable = []
        
        var index: Int = 0
        CardSymbol.allCases.forEach { symbol in
            NumberOfShapes.allCases.forEach{ numberOfShapes in
                CardColor.allCases.forEach { color in
                    Shading.allCases.forEach{ shading in
                        let card = Card(id: index, shape: symbol, numberOfShapes: numberOfShapes, color: color, shading: shading)
                        deck.append(card)
                        index += 1
                    }
                }
            }
        }
        
        deck = deck.shuffled()
        for _ in 0...11 {
            cardsOnTable.append(deck.removeFirst())
        }
    }
    
    mutating func addThreeCards() {
        if deck.count > 0 {
            for _ in 0...2 {
                cardsOnTable.append(deck.removeFirst())
            }
        }
    }
    
//    mutating func selectCard(_ id: Int) {
//        cardsOnTable.first(where: <#T##(Card) throws -> Bool#>)
//    }
    
    struct Card: Identifiable {
        let id: Int
        let shape: CardSymbol
        let numberOfShapes: NumberOfShapes
        let color: CardColor
        let shading: Shading
    }
    
    enum CardSymbol: Int, CaseIterable {
        case capsule = 1, rectangle, diamond
        
        func getView() -> some Shape{
            var selectedShape: AnyShape {
                switch self {
                case .capsule:
                    return AnyShape(Capsule())
                case .rectangle:
                    return AnyShape(Rectangle())
                case .diamond:
                    return AnyShape(Diamond())
                }
            }
            return selectedShape
        }
    }
    
    enum Shading: Int, CaseIterable {
        case filledIn = 1 , outline, striped

        func getShading<SomeShape: Shape>(_ view: SomeShape) -> some View{
            switch self {
            case .filledIn:
                return  AnyView(view.opacity(1))
            case .outline:
                return  AnyView(view.stroke())
            case .striped:
                return AnyView(view.opacity(0.4))
            }
        }
    }
    
    enum CardColor: Int, CaseIterable {
        case red = 1, green, blue
        var value: Color {
            switch self {
            case .red:
                return .red
            case .green:
                return .green
            case .blue:
                return .blue
            }
        }
    }
    
    enum NumberOfShapes: Int, CaseIterable {
        case one = 1, two, three
    }
}
