//
//  Game.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 3/7/2022.
//

import Foundation
import GameKit



class GameManager: NSObject, GKLocalPlayerListener, ObservableObject {
    
    @Published var games: [String:GameState] = [:]
    
    override init() {
        super.init()
        GKLocalPlayer.local.register(self)
    }
    
    func player(_ player: GKPlayer, receivedTurnEventFor match: GKTurnBasedMatch, didBecomeActive: Bool) {
        var gameState = (try? GameState.decode(match.matchData!)) ?? GameState()
        
        gameState.registerOnMove { gs in
            do {
                if (gs.isGameOver) {
                    try match.endMatchInTurn(withMatch: gs.encode())
                    return
                }
                
                try match.endTurn(
                    withNextParticipants: match.participants.filter({ GKTurnBasedParticipant in
                        GKTurnBasedParticipant.player != GKLocalPlayer.local
                    }),
                    turnTimeout: GKTurnTimeoutNone,
                    match: gs.encode()
                )
            }
            catch {
                print(error)
            }
        }
        
        self.games[match.matchID] = gameState
    }
}
