//
//  Game.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 12/10/21.
//

import Foundation

class GameCollection: ObservableObject {
    
    @Published var games: [UUID: GameState] = [:]
    
    init() {
        
    }
    
    func startGame(gameState: GameState, player1: PlayerProto, player2: PlayerProto) {
        self.games[gameState.id] = gameState
    }
    
    func clearGame(id: UUID) {
        self.games.removeValue(forKey: id)
    }
    
    
}
