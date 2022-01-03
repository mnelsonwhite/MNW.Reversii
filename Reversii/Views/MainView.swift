//
//  MainView.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 5/10/21.
//

import Foundation
import SwiftUI

struct MainView: View {
    
    
    var body: some View {
        VStack {
            NavigationView {
                GamesView()
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        NavigationLink(destination: ObserveView()) {
                            Label("Observe", systemImage: "binoculars")
                        }
                        NavigationLink(destination: HistoryView()) {
                            Label("History", systemImage: "text.book.closed")
                        }
                        NavigationLink(destination: RankingView()) {
                            Label("Ranking", systemImage: "list.number")
                        }
                    }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            
    }
}
