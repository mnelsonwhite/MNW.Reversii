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
    @EnvironmentObject var user: UserModel
    @StateObject var gameState = GameState()
    
    var body: some View {
        ZStack {
            VStack {
                BoardView(gameState: self.gameState)
                Spacer()
            }
            .scaledToFit()
            if (self.gameState.isGameOver) {
                Text("Game Over")
                    .font(.system(.largeTitle))
                    .padding()
                    .background(self.colorScheme == .light ? Color.black : Color.white)
                    .foregroundColor(self.colorScheme == .light ? Color.white : Color.black)
                    .clipShape(Capsule())
                    .onTapGesture {
                        self.gameState.reset()
                    }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
}
