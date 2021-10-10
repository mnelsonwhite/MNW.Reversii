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
    
    @State private var piece: Pieces = .white
    
    let timer = Timer.publish(every: 2 , on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            VStack{
                PieceView(piece: self.$piece)
                    .padding(100)
                    .onReceive(timer) { input in
                        self.piece = self.piece == .white ? .black : .white
                    }
                
                Text("REVERSII")
                    .font(.system(.largeTitle))
                
                
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
