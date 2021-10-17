//
//  ScoreView.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 12/10/21.
//

import Foundation
import SwiftUI

struct ScoreView: View {
    @Binding var gameState: GameState
    
    var body: some View {
        
        HStack {
            HStack {
                Text("White")
                    .bold()
                Text("\(self.gameState.score.white)")
                if self.gameState.playerTurn == .white {
                    Image(systemName: "arrow.left.circle.fill")
                }
            }
                .padding(10)
            Spacer()
            HStack {
                if self.gameState.playerTurn == .black {
                    Image(systemName: "arrow.right.circle.fill")
                }
                Text("Black")
                    .bold()
                Text("\(self.gameState.score.black)")
            }
            .padding(10)
        }
        
    }
}


struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView(gameState: .constant(GameState()))
            .preferredColorScheme(.light)
    }
}
