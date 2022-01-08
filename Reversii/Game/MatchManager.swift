//
//  Game.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 12/10/21.
//

import Foundation
import GameKit

class MatchManager: NSObject, ObservableObject {
    @Published var gameStates: [String: GameState] = [:]
    
    private let playerId: String
    
    override init() {
        self.playerId = GKLocalPlayer.local.teamPlayerID
        super.init()
        
        GKLocalPlayer.local.register(self)
    }
    
    func addMatch(
        _ id: String,
        gameOptions: GameOptions,
        match: GKTurnBasedMatch
    ) {
        let opponent = match.participants[1]
        let selfIsWhite = (self.playerId.hashValue ^ opponent.player!.teamPlayerID.hashValue) % 2 == 0 ? true : false
        
        self.gameStates[id] = GameState(
            clockDuration: gameOptions.clockTime == 0 ? nil : TimeInterval(gameOptions.clockTime * 60),
            whitePlayerId: selfIsWhite ? self.playerId : opponent.player!.teamPlayerID,
            blackPlayerId: !selfIsWhite ? self.playerId : opponent.player!.teamPlayerID
        )
        
        /*match.endTurn(
            withNextParticipants: <#T##[GKTurnBasedParticipant]#>,
            turnTimeout: TimeInterval(gameOptions.clockTime * 60),
            match: <#T##Data#>,
            completionHandler: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>
        )*/
    }
    
    func removeGame(_ id: String) {
        self.gameStates.removeValue(forKey: id)
    }
    
    private func updateGame(id: String, gameState: GameState) {
        self.gameStates[id] = gameState
    }
}

extension MatchManager: GKLocalPlayerListener {
    /// called when it becomes this player's turn.  It also gets called under the following conditions:
    ///      the player's turn has a timeout and it is about to expire.
    ///      the player accepts an invite from another player.
    /// when the game is running it will additionally recieve turn events for the following:
    ///      turn was passed to another player
    ///      another player saved the match data
    /// Because of this the app needs to be prepared to handle this even while the player is taking a turn in an existing match.  The boolean indicates whether this event launched or brought to forground the app.
    func player(
        _ player: GKPlayer,
        receivedTurnEventFor match: GKTurnBasedMatch,
        didBecomeActive: Bool
    ) {
        guard let data = match.matchData, let gameState = try? GameState.decode(data) else {
            return
        }
        
        self.updateGame(id: match.matchID, gameState: gameState)
    }
    
    /// called when the match has ended.
    func player(_ player: GKPlayer, matchEnded match: GKTurnBasedMatch) {
        self.removeGame(match.matchID)
    }
    
    /// Called when a player chooses to quit a match and that player has the current turn.  The developer should call participantQuitInTurnWithOutcome:nextParticipants:turnTimeout:matchData:completionHandler: on the match passing in appropriate values.  They can also update matchOutcome for other players as appropriate.
    func player(_ player: GKPlayer, wantsToQuitMatch match: GKTurnBasedMatch) {
        self.removeGame(match.matchID)
    }
}
