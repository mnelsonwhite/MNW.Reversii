//
//  ComputerPlayer.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 4/7/2022.
//

import Foundation
import GameKit

class ComputerPlayer: NSObject, GKLocalPlayerListener {
    var player: GKLocalPlayer?
    
    override init() {
        super.init()
    }

    func register() {
        self.player = GKLocalPlayer.anonymousGuestPlayer(withIdentifier: UUID.init().uuidString)
        self.player?.register(self)
    }
    
    func player(_ player: GKPlayer, receivedTurnEventFor match: GKTurnBasedMatch, didBecomeActive: Bool) {
        
    }
}
