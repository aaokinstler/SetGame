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
    
    
}
