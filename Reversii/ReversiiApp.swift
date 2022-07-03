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
    
    var body: some Scene {
        WindowGroup {
            Section() {
                ZStack {
                    GameManagerView(
                        isAuthenticated: self.$isUserAuthenticated
                    )
                    
                    if self.isUserAuthenticated {
                        MainView(gameManager: GameManager())
                    }
                    else {
                        Text("Logging In")
                    }
                }
            }
        }
    }
}
