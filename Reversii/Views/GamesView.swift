//
//  GamesView.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 18/10/21.
//

import SwiftUI

struct GamesView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var matches = MatchManager()
    
    var body: some View {
        ScrollView {
            VStack {
                
                CreateGameView()
            }
        }.navigationTitle("Games")
    }
}

struct GamesView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView()
    }
}
