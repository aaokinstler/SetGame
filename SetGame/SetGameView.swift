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
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                ForEach(game.cardsOnTable) { card in
                    CardView(card: card).aspectRatio(2/3, contentMode: .fit)
                }
            }
        }.padding()
    }
}



struct CardView: View {
    
    let card: SetGameModel.Card
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10).strokeBorder()
            VStack{
                ForEach(0..<card.numberOfShapes.rawValue) {_ in
                    let shape = card.shape.getView() 
                    card.shading.getShading(shape).aspectRatio(2/1, contentMode: .fit)
                }
            }
            .padding()
            .foregroundColor(card.color.value)
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(game: SetGame())
.previewInterfaceOrientation(.portrait)
    }
}
