//
//  BoardView.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 9/10/21.
//

import SwiftUI

struct BoardView: View {
    @Binding var gameState: GameState
    
    var body: some View {
        let validMoves = self.gameState.validMoves()
        GeometryReader { geometry in
            VStack(spacing: 3) {
                ForEach(1 ..< self.gameState.boardSize + 1) { y in
                    HStack(spacing: 3) {
                        ForEach(1 ..< self.gameState.boardSize + 1) { x in
                            let position = Position(x: x, y: y, size: self.gameState.boardSize)
                            
                            ZStack {
                                Rectangle()
                                    .fill(.gray)
                                if let piece = self.gameState.pieces[position.ordinal] {
                                    PieceView(piece: .constant(piece))
                                        .padding(3)
                                }
                                else if validMoves.contains(position) {
                                    Image(systemName: "xmark")
                                        .onTapGesture {
                                            if !self.gameState.tryPmove(position: position) {
                                                print("Invalid Move", position)
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
            }
            .padding(3)
            .frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(gameState: .constant(GameState()))
            .preferredColorScheme(.light)
    }
}
