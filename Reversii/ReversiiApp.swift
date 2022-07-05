//
//  ReversiiApp.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 30/9/21.
//

import SwiftUI
import GameKit


@main

struct ReversiiApp: App {
    @State var isUserAuthenticated: Bool = false
    private let gameManager: GameManager = GameManager()
    private let computerPlayer: ComputerPlayer = ComputerPlayer()
    
    var body: some Scene {
        WindowGroup {
            Section() {
                ZStack {
                    GameManagerView(
                        isAuthenticated: self.$isUserAuthenticated,
                        onAuthenticated: {
                            self.gameManager.register()
                            self.gameManager.loadMatches()
                            self.computerPlayer.register()
                        }
                    )
                    
                    if self.isUserAuthenticated {
                        MainView(gameManager: self.gameManager, computerPlayer: self.computerPlayer)
                    }
                    else {
                        Text("Logging In")
                    }
                }
            }
        }
    }
}
