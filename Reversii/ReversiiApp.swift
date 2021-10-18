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
    
    var body: some Scene {
        WindowGroup {
            Section() {
                ZStack {
                    GameManagerView(isAuthenticated: self.$isUserAuthenticated)
                    
                    if self.isUserAuthenticated {
                        MainView()
                    }
                    else {
                        Text("Logging In")
                    }
                }
            }
        }
    }
}
