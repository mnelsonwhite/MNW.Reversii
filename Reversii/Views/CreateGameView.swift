//
//  CreateGameView.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 18/10/21.
//

import SwiftUI

struct CreateGameView: View {
    @State private var random: Bool = true
    @State private var opponent: String = ""
    @State private var rated: Bool = true
    @State private var clock: Int = 5
    
    var body: some View {
        Form {
            Section {
                Toggle("Random Opponent", isOn: self.$random)
                if !self.random {
                    TextField("Invite Opponent", text: self.$opponent)
                }
                Toggle("Rated Game", isOn: self.$rated)
                Picker("Game Clock", selection: $clock) {
                    Text("Unlimited").tag(0)
                    Text("1 Minute").tag(1)
                    Text("2 Minutes").tag(2)
                    Text("3 Minutes").tag(3)
                    Text("5 Minutes").tag(5)
                    Text("10 Minutes").tag(10)
                    Text("15 Minutes").tag(15)
                }
                Button(action : {
                }, label: {
                    Text("Create Game")
                })
            }
        }.scaledToFit()
    }
}

struct CreateGameView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGameView()
    }
}
