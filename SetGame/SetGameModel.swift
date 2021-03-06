//
//  SetGameModel.swift
//  SetGame
//
//  Created by Anton Kinstler on 22.12.2021.
//

import Foundation
import SwiftUI

struct SetGameModel {
    private(set) var deck: Array<Card>
    private(set) var cardsOnTable: Array<Card>
    private(set) var discardPile: Array<Card>
    private(set) var arrayOfIdsOfChosenCards: Array<Int> = []
    private(set) var isMatched = false
    
    var cardsInDeck: Int {
        deck.count
    }
    
    init() {
        
        deck = []
        cardsOnTable = []
        discardPile = []
        
        var index: Int = 1
        CardSymbol.allCases.forEach { symbol in
            NumberOfShapes.allCases.forEach { numberOfShapes in
                CardColor.allCases.forEach { color in
                    Shading.allCases.forEach { shading in
                        let card = Card(id: index, shape: symbol, numberOfShapes: numberOfShapes, color: color, shading: shading)
                        deck.append(card)
                        index += 1
                    }
                }
            }
        }
        
        deck = deck.shuffled()
    }
        
    mutating func addCardOnTable() {
        if !deck.isEmpty {
            cardsOnTable.append(deck.removeLast())
        }
    }
    
    mutating func addCardOnTable(_ index: Int) {
        if !deck.isEmpty {
            cardsOnTable[index] = deck.removeLast()
        }
    }
    
    mutating func removeCardFromTable(cardId: Int) {
        guard let cardIndex = cardsOnTable.firstIndex(where: {$0.id == cardId}) else {
            return
        }
        discardPile.append(cardsOnTable.remove(at: cardIndex))
    }
    
    mutating func removeCardFromTable(_ index: Int) {
        if !cardsOnTable.isEmpty {
            discardPile.append(cardsOnTable[index])
//            cardsOnTable[index] = nil
            
        }
    }
    
    func getChosenCardsIndices() -> [Int] {
        var indices = Array<Int>()
        arrayOfIdsOfChosenCards.forEach { id in
            indices.append(cardsOnTable.firstIndex(where: {$0.id == id})!)
        }
        return indices.sorted()
    }
    
    mutating func selectCard(_ id: Int) {
        var deselect = false
        if let selectetdCardIndex = arrayOfIdsOfChosenCards.firstIndex(where: {$0 == id}) {
            if arrayOfIdsOfChosenCards.count != 3 {
                arrayOfIdsOfChosenCards.remove(at: selectetdCardIndex)
                return
            } else {
                deselect = true
            }
        }
        
        if deck.isEmpty && cardsOnTable.count == 3 && arrayOfIdsOfChosenCards.count == 2 {
            cardsOnTable.removeAll()
            return
        }
        
        if arrayOfIdsOfChosenCards.count == 3 {
//            if isMatched {
//                arrayOfIdsOfChosenCards.forEach { id in
//                    let cardIndex = cardsOnTable.firstIndex(where: {$0.id == id})!
//                    if deck.count > 0 {
//                        discardPile.append(cardsOnTable.remove(at: cardIndex))
//                        cardsOnTable[cardIndex] = deck.removeFirst()
//                    } else {
//                        discardPile.append(cardsOnTable.remove(at: cardIndex))
//                    }
//                }
//            }
            isMatched = false
            arrayOfIdsOfChosenCards.removeAll()
        }
        
        if !deselect {
            arrayOfIdsOfChosenCards.append(id)
        }
        
        if arrayOfIdsOfChosenCards.count == 3 {
            isMatched = checkMatchingOfCards()
        }
    }
    
    private func checkMatchingOfCards() -> Bool {
        
        return true
        
        let arrayOfChosenCards = cardsOnTable.filter {Set(arrayOfIdsOfChosenCards).contains($0.id)}
        
        if !checkMatchingOfProperties(arrayOfChosenCards.map{$0.shape.rawValue}) {
            return false
        }
        
        if !checkMatchingOfProperties(arrayOfChosenCards.map{$0.numberOfShapes.rawValue}) {
            return false
        }
        
        if !checkMatchingOfProperties(arrayOfChosenCards.map{$0.color.rawValue}) {
            return false
        }
        
        if !checkMatchingOfProperties(arrayOfChosenCards.map{$0.shading.rawValue}) {
            return false
        }
        
        return true
    }
    
    private func checkMatchingOfProperties(_ properties: [Int]) -> Bool {
        let diffValuesCount = Set(properties).count
        var isMatched = false
        if diffValuesCount == 1 || diffValuesCount == 3 {
            isMatched = true
        }
        return isMatched
    }
    
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
