//
//  MainView.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 5/10/21.
//

import Foundation
import SwiftUI

struct MainView: View {
    @State private var activeView = Views.games
    
    var body: some View {
        NavigationView {
            switch self.activeView {
                case Views.ranking: RankingView()
                case Views.history: HistoryView()
                case Views.observe: ObserveView()
                case Views.games: GamesView()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button {
                    self.activeView = Views.games
                } label: {
                    Label("Games", systemImage: "gamecontroller")
                }
                Button {
                    self.activeView = Views.observe
                } label: {
                    Label("Observe", systemImage: "binoculars")
                }
                Button {
                    self.activeView = Views.history
                } label: {
                    Label("History", systemImage: "text.book.closed")
                }
                Button {
                    self.activeView = Views.ranking
                } label: {
                    Label("Ranking", systemImage: "list.number")
                }
            }
        }
    }
    
    private enum Views: Int, Codable {
        case games = 0
        case observe = 1
        case history = 2
        case ranking = 3
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
