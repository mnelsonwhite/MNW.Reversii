//
//  MatchMakerView.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 3/1/2022.
//

import Foundation
import GameKit
import SwiftUI

// https://github.com/SwiftPackageRepository/GameKitUI.swift
struct MatchMakerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private let request: GameRequest
    private let cancelled: () -> Void
    private let failed: (Error) -> Void
    private let started: (GKMatch) -> Void
    
    init(request: GameRequest,
         cancelled: @escaping () -> Void = {},
         failed: @escaping (Error) -> Void = {_ in },
         started: @escaping (GKMatch) -> Void = {_ in }) {
        self.request = request
        self.cancelled = cancelled
        self.failed = failed
        self.started = started
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MatchMakerView>) -> GKMatchmakerViewController {
        let gkRequest = GKMatchRequest()
        gkRequest.minPlayers = 2
        gkRequest.maxPlayers = 2
        gkRequest.defaultNumberOfPlayers = 2
        gkRequest.inviteMessage = "Play Reversi"
        gkRequest.playerGroup = self.request.toInt()
        
        let matchmakerViewController = GKMatchmakerViewController(matchRequest: gkRequest)
        matchmakerViewController!.matchmakerDelegate = context.coordinator
        return matchmakerViewController!
    }
    
    func updateUIViewController(_ uiViewController: GameManagerController, context: UIViewControllerRepresentableContext<GameManagerView>) { }
    
    func updateUIViewController(_ uiViewController: GKMatchmakerViewController, context: Context) { }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, GKMatchmakerViewControllerDelegate {
        let parent: MatchMakerView
        
        init(_ parent: MatchMakerView) {
            self.parent = parent
        }
        
        func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
            viewController.dismiss(
                animated: true,
                completion: {
                    self.parent.cancelled()
                    viewController.removeFromParent()
                    self.parent.presentationMode.wrappedValue.dismiss()
            })
            
        }
        
        func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
            viewController.dismiss(
                animated: true,
                completion: {
                    self.parent.failed(error)
                    viewController.removeFromParent()
                    self.parent.presentationMode.wrappedValue.dismiss()
            })
        }
        
        func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
            viewController.dismiss(
                animated: true,
                completion: {
                    self.parent.started(match)
                    viewController.removeFromParent()
                    self.parent.presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    enum MatchMakerError: Error {
        case unableToCreate
    }
}
