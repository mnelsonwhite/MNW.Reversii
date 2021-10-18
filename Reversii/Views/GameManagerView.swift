//
//  GameController.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 17/10/21.
//

import Foundation
import GameKit
import SwiftUI

protocol GameManagerControllerDelegate: NSObjectProtocol {
    func userAuthenticationChange(isUserAuthenticated: Bool)
}

class GameManagerController: UIViewController {
    private let player = GKLocalPlayer.local
    
    var delegate: GameManagerControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticatePlayer(player: self.player)
    }
    
    private func authenticatePlayer(player: GKLocalPlayer) {
        player.authenticateHandler = { viewController, error in
            if let error = error {
                print(error)
                return
            }
            
            if let viewController = viewController {
                print(self.player)
                self.present(viewController, animated: true)
            }
            
            if #available(iOS 14.0, *) {
                GKAccessPoint.shared.location = .topTrailing
                GKAccessPoint.shared.showHighlights = true
                GKAccessPoint.shared.isActive = self.player.isAuthenticated
            }
            
            if let delegate = self.delegate {
                delegate.userAuthenticationChange(isUserAuthenticated: self.player.isAuthenticated)
            }
            
        }
    }
}

struct GameManagerView: UIViewControllerRepresentable {
    @Binding var isAuthenticated: Bool
    
    class Coordinator: NSObject, UINavigationControllerDelegate, GameManagerControllerDelegate {
        let parent: GameManagerView
        
        init(_ parent: GameManagerView) {
            self.parent = parent
        }
        
        func userAuthenticationChange(isUserAuthenticated: Bool) {
            self.parent.isAuthenticated = isUserAuthenticated
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<GameManagerView>) -> GameManagerController {
        let viewController = GameManagerController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: GameManagerController, context: UIViewControllerRepresentableContext<GameManagerView>) {
    }
}
