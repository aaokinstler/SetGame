//
//  SetGame.swift
//  SetGame
//
//  Created by Anton Kinstler on 23.12.2021.
//

import Foundation

class SetGame: ObservableObject {
    
    @Published private var model = SetGameModel()
    
    
    var cardsOnTable: Array<SetGameModel.Card> {
        return model.cardsOnTable
    }
    
    var cardsInDeck: Int {
        return model.cardsInDeck
    }
    
    var isMatched: Bool {
        return model.isMatched
    }
    
    var arrayOfChosenCards: Array<Int> {
        return model.arrayOfIdsOfChosenCards
    }
    
    func selectCard(_ id: Int) {
        model.selectCard(id)
    }
    
    func addThreeCards() {
        model.addThreeCards()
    }
    
    func newGame() {
        model = SetGameModel()
    }
    
}
