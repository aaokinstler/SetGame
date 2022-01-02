//
//  ContentView.swift
//  SetGame
//
//  Created by Anton Kinstler on 22.12.2021.
//

import SwiftUI

struct SetGameView: View {
    
    @ObservedObject var game: SetGame
    
    @Namespace private var cardTableNamespace
    
    var color: Color {
        if game.arrayOfChosenCards.count == 3 {
            if game.isMatched {
                return .green
            } else {
                return .red
            }
        } else {
            return .yellow
        }
    }
    
    var body: some View {
        VStack {
            gameBody
            bottomBar
        }
    }
    
    
    var gameBody: some View {
        if game.cardsOnTable.count <= 24 {
            return AnyView( AspectVGrid(items: game.cardsOnTable, aspectRatio: 2/3) { card in
                let isSelected = game.arrayOfChosenCards.contains(where: {$0 == card.id})
                CardView(card: card, isSelected: isSelected, color: color, isFaceUp: true)
                    .matchedGeometryEffect(id: card.id, in: cardTableNamespace)
                    .padding(4)
                    .aspectRatio(2/3, contentMode: .fit)
                    .transition(.identity)
                    .onTapGesture {
                        cardOnTap(card.id)
                    }
            })
        } else {
            return AnyView( ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 55))]) {
                    ForEach(game.cardsOnTable) { card in
                        let isSelected = game.arrayOfChosenCards.contains(where: {$0 == card.id})
                        CardView(card: card, isSelected: isSelected, color: color, isFaceUp: true)
                            .matchedGeometryEffect(id: card.id, in: cardTableNamespace)
                            .aspectRatio(2/3, contentMode: .fit)
                            .transition(.identity)
                            .onTapGesture {
                                cardOnTap(card.id)
                            }
                    }
                }
            }.padding(.horizontal))
        }
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.deck) { card in
                CardView(card: card, isSelected: false, color: .yellow)
                    .matchedGeometryEffect(id: card.id, in: cardTableNamespace)
                    .aspectRatio(2/3, contentMode: .fit)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .onTapGesture {
            withAnimation {
                if game.cardsOnTable.isEmpty {
                    dealNewGame()
                } else {
                    dealThreeCards()
                }
            }
        }
    }
    
    var discardPileBody: some View {
        ZStack {
            ForEach(game.discardPile) { card in
                CardView(card: card, isFaceUp: true)
                    .matchedGeometryEffect(id: card.id, in: cardTableNamespace)
                    .aspectRatio(CardConstants.aspectRatio, contentMode: .fit)
                    .transition(.identity)
            }
        }
    }
    
    private func cardOnTap(_ id: Int) {
        if game.isMatched {
            removeMatchedCardsFromTable()
        }
        game.selectCard(id)
    }
    
    private func removeMatchedCardsFromTable() {
        let indices = game.getChosenCardsIndices()
        
        var indexNumber = 0
        indices.forEach { index in
            withAnimation(dealAnimation(indexNumber, 0.5, indices.count)) {
                game.removeCardFromTable(index)
            }
            
            withAnimation(dealAnimation(indexNumber, 0.5, indices.count, 0.5)) {
                game.addCardOnTable(index)
            }
            indexNumber += 1
        }
    }
    
    private func dealNewGame() {
        let limit = 12
        for index in 0..<limit {
            withAnimation(dealAnimation(index, 2, limit)){
                game.addCardOnTable()
            }
        }
    }
    
    private func dealThreeCards() {
        let limit = 3
        for index in 0..<3 {
            withAnimation(dealAnimation(index, 0.5, limit)) {
                game.addCardOnTable()
            }
        }
    }
    
    private func moveMatchedCardsToDiscard() {
        var index = 0
        game.arrayOfChosenCards.forEach { cardId in
            withAnimation(dealAnimation(index, 1, game.arrayOfChosenCards.count)) {
                game.removeCardFromTable(cardId)
                index += 1
            }
        }
    }
    
    private func dealAnimation(_ index: Int, _ totalDealDuration: Double, _ amountOfCards: Int) -> Animation {
        let delay = Double(index) * (Double(totalDealDuration) / Double(amountOfCards))
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func dealAnimation(_ index: Int, _ totalDealDuration: Double, _ amountOfCards: Int, _ additionalDelay: Double) -> Animation {
        let delay = Double(index) * (Double(totalDealDuration) / Double(amountOfCards)) + additionalDelay
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    var bottomBar: some View {
        HStack{
            deckBody
            Spacer()
            VStack{
                Spacer()
                Text("\(String(game.cardsInDeck))")
                Spacer()
                newGame
                Spacer()
            }
            Spacer()
            discardPileBody
        }
        .padding(.horizontal)
        .frame(height: 140 )
    }
    
    var newGame: some View {
        Button {
            game.newGame()
        } label: {
            Text("New game")
        }
    }
    
    private struct CardConstants {
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}



struct CardView: View {
    
    let card: SetGameModel.Card
    var isSelected = false
    var color = Color.yellow
    var isFaceUp = false
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                let cardShape = RoundedRectangle(cornerRadius: 10)
                RoundedRectangle(cornerRadius: 10).foregroundColor(.white)
                if isFaceUp {
                    VStack{
                        ForEach(0..<card.numberOfShapes.rawValue) {_ in
                            let shape = card.shape.getView()
                            card.shading.getShading(shape).aspectRatio(2/1, contentMode: .fit)
                        }
                    }
                    .padding(geometry.size.width * 0.13)
                    .foregroundColor(card.color.value)
                    
                    if isSelected {
                        cardShape.strokeBorder(style: StrokeStyle(lineWidth: 5)).foregroundColor(color)
                    } else {
                        cardShape.strokeBorder()
                    }
                } else {
                    cardShape
                }
                
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
