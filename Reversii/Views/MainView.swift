//
//  MainView.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 5/10/21.
//

import Foundation
import SwiftUI

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var game = GameCollection()
    
    var body: some View {
        ZStack {
            
            /*if let gameState = self.game.games {
                ZStack {
                    GameView(gameState: $gameState)
                    
                    if gameState.isGameOver {
                        Text("Game Over")
                            .font(.system(.largeTitle))
                            .padding()
                            .background(self.colorScheme == .light ? Color.black : Color.white)
                            .foregroundColor(self.colorScheme == .light ? Color.white : Color.black)
                            .clipShape(Capsule())
                            .onTapGesture {
                                self.game.clearGame()
                            }
                    }
                        
                }
            }
            else {
                
            }*/
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(UserModel())
            .preferredColorScheme(.dark)
    }
}
