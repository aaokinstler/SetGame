//
//  SetGame.swift
//  SetGame
//
//  Created by Anton Kinstler on 23.12.2021.
//

import Foundation

class SetGame: ObservableObject {
    
    typealias Card = SetGameModel.Card
    
    @Published private var model = SetGameModel()
    
    var cardsOnTable: Array<Card> {
        return model.cardsOnTable
    }
    
    var deck: Array<Card> {
        return model.deck
    }
    
    var discardPile: Array<Card> {
        return model.discardPile
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
    
    func addCardOnTable() {
        model.addCardOnTable()
    }
    
    func addCardOnTable(_ index: Int) {
        model.addCardOnTable(index)
    }
    
    func removeCardFromTable(_ cardId: Int) {
        model.removeCardFromTable(cardId)
    }
    
    func getChosenCardsIndices() -> [Int] {
        model.getChosenCardsIndices()
    }
    
    func newGame() {
        model = SetGameModel()
    }
    
}
