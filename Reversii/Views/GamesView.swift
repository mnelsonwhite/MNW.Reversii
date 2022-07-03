//
//  GamesView.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 18/10/21.
//

import SwiftUI

struct GamesView: View {
    @Environment(\.colorScheme) var colorScheme
    var matchManager = MatchManager()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(Array(self.matchManager.gameStates.keys).sorted(by: <), id: \.self) { key in
                    VStack {
                        Text(key)
                        if let gameState = self.matchManager.gameStates[key] {
                            GameView(gameState: gameState)
                        }
                    }
                }
                CreateGameView(createGame: { id, gameState in
                    self.matchManager.addMatch(id, gameState: gameState)
                })
            }
        }.navigationTitle("Games")
    }
}

struct GamesView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView()
    }
}
