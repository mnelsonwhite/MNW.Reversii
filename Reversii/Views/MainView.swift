//
//  MainView.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 5/10/21.
//

import Foundation
import SwiftUI

struct MainView: View {
    @State var createGame: Bool = false
    @ObservedObject var gameManager: GameManager
    let computerPlayer: ComputerPlayer
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Button("Create Game") {
                        self.createGame = true
                    }
                    
                    Divider()
                    
                    ForEach(self.gameManager.games.sorted(by: {a,b in a.key > b.key}), id: \.key) { key, value in
                        GameView(gameState: value)
                        Button("Remove Game") {
                            self.gameManager.remove(matchId: key)
                        }
                        Divider()
                    }
                    
                    if self.gameManager.games.isEmpty {
                        Text("No games")
                    }
                }
            }
            
            if(createGame) {
                MatchMakerView(
                    request: GameOptions(
                        rated: false,
                        voiceEnabled: false,
                        playComputer: true,
                        clockTime: 0
                    ),
                    cancelled: {
                        self.createGame = false
                    },
                    failed: { error in
                        print(error)
                        self.createGame = false
                    },
                    started: { match in
                        print(match)
                        self.createGame = false
                    },
                    computerPlayer: self.computerPlayer
                )
            }
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static func GetGameManager() -> GameManager {
        let gameManager = GameManager()
        gameManager.games["test game"] = GameState()
        return gameManager
    }
    
    static var previews: some View {
        MainView(gameManager: GetGameManager(), computerPlayer: ComputerPlayer())
    }
}
