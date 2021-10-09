//
//  ReversiiApp.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 30/9/21.
//

import SwiftUI


@main

struct ReversiiApp: App {
    @StateObject private var user = UserModel()
    
    var body: some Scene {
        WindowGroup {
            Section() {
                if self.user.isAuthorised {
                    MainView()
                }
                else {
                    LoginView()
                }

            }
            .environmentObject(self.user)
        }
    }
}
