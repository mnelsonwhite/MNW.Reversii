//
//  MainView.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 5/10/21.
//

import Foundation
import SwiftUI

struct MainView: View {
    @EnvironmentObject var user: UserModel
    
    var body: some View {
        Text("\(self.user.identity?.givenName ?? "Unknown") Logged In")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
}
