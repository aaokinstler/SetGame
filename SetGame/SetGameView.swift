//
//  ContentView.swift
//  SetGame
//
//  Created by Anton Kinstler on 22.12.2021.
//

import SwiftUI

struct SetGameView: View {
    
    @ObservedObject var game: SetGame
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(game.cardsOnTable) { card in
                        let isSelected = game.arrayOfChosenCards.contains(where: {$0 == card.id})
                        CardView(card: card, isSelected: isSelected)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                game.selectCard(card.id)
                            }
                    }
                }
            }.padding(.horizontal)
            bottomBar
        }
    }
    
    var bottomBar: some View {
        HStack{
            newGame
            Spacer()
            Text("\(String(game.cardsInDeck))")
            Spacer()
            addThreeCards
        }.padding()
    }
    
    var addThreeCards: some View {
        Button {
            game.addThreeCards()
        } label: {
            Text("Add cards")
        }.disabled(game.cardsInDeck == 0)
    }
    
    var newGame: some View {
        Button {
            game.newGame()
        } label: {
            Text("New game")
        }
    }
}



struct CardView: View {
    
    let card: SetGameModel.Card
    let isSelected: Bool
    
    var body: some View {
        ZStack{
            let cardShape = RoundedRectangle(cornerRadius: 10)
            VStack{
                ForEach(0..<card.numberOfShapes.rawValue) {_ in
                    let shape = card.shape.getView() 
                    card.shading.getShading(shape).aspectRatio(2/1, contentMode: .fit)
                }
            }
            .padding()
            .foregroundColor(card.color.value)
            
            if isSelected {
                cardShape.strokeBorder(style: StrokeStyle(lineWidth: 5)).foregroundColor(.yellow)
            } else {
                cardShape.strokeBorder()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(game: SetGame())
.previewInterfaceOrientation(.portrait)
    }
}
