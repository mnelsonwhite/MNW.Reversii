//
//  CreateGameView.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 18/10/21.
//

import SwiftUI
import GameKit

struct CreateGameView: View {
    @State private var rated: Bool = true
    @State private var clockTime: Int = 5
    @State private var voiceEnabled: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    // Toggle("Voice Enabled", isOn: self.$voiceEnabled)
                    Toggle("Rated Game", isOn: self.$rated)
                    Picker("Clock Time", selection: $clockTime) {
                        Text("Unlimited").tag(0)
                        Text("1 Minute").tag(1)
                        Text("5 Minutes").tag(5)
                        Text("10 Minutes").tag(10)
                        Text("15 Minutes").tag(15)
                    }
                }
                NavigationLink(destination: createGame) {
                    Text("Find Match")
                }
            }
        }.scaledToFill()
    }
    
    private func createGame() -> MatchMakerView {
        return MatchMakerView(
            request: GameOptions(
                rated: self.rated,
                voiceEnabled: self.voiceEnabled,
                clockTime: self.clockTime
            ),
            started: {match in
                print(match)
            }
        )
    }
}

struct CreateGameView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGameView()
    }
}
