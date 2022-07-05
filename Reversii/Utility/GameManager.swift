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
    private var matches: [String:GKTurnBasedMatch] = [:]
    
    func register() {
        GKLocalPlayer.local.register(self)
    }
    
    func loadMatches() {
        GKTurnBasedMatch.loadMatches { matches, error in
            guard matches != nil else {
                return
            }
            
            for match in matches! {
                self.matches[match.matchID] = match
                if let data = match.matchData {
                    if let gameState = try? GameState.decode(data) {
                        self.games[match.matchID] = gameState
                    }
                }
            }
        }
    }
    
    func remove(matchId: String) {
        if let match = self.matches[matchId] {
            match.remove(completionHandler: {error in
                if error == nil {
                    self.matches.removeValue(forKey: matchId)
                    self.games.removeValue(forKey: matchId)
                }
            })
        }
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
        self.matches[match.matchID] = match
    }
}
