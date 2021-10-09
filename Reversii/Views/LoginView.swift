//
//  ContentView.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 30/9/21.
//

import SwiftUI
import AuthenticationServices

// https://www.youtube.com/watch?v=rANIxrkso2I
struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var user: UserModel
    
    var body: some View {
        ZStack{
            VStack{
                VStack{
                    HStack{
                        Image(systemName: "circle.fill")
                            .resizable()
                            .scaledToFit()
                        Image(systemName: "circle")
                            .resizable()
                            .scaledToFit()
                    }
                    HStack{
                        Image(systemName: "circle")
                            .resizable()
                            .scaledToFit()
                        Image(systemName: "circle.fill")
                            .resizable()
                            .scaledToFit()
                    }
                }
                .padding(100)
                
                Spacer()
                
                SignInWithAppleButton(.signIn, onRequest: self.user.request(_:), onCompletion: self.user.handle(_:))
                    .signInWithAppleButtonStyle(
                        colorScheme == .dark ? .white : .black
                    )
                    .padding(7)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 76)
                
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserModel())
            .preferredColorScheme(.dark)
    }
}
