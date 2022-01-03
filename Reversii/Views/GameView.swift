//
//  GameView.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 12/10/21.
//

import SwiftUI

struct GameView: View {
    @State var gameState: GameState
    
    var body: some View {
        HStack {
            VStack {
                ScoreView(gameState: self.$gameState)
                BoardView(gameState: self.$gameState)
            }
        }
        
        
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameState: GameState())
    }
}
