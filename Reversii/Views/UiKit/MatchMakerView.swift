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
    private let request: GameOptions
    private let cancelled: () -> Void
    private let failed: (Error) -> Void
    private let started: (GKTurnBasedMatch) -> Void
    
    init(
        request: GameOptions,
        cancelled: @escaping () -> Void = {},
        failed: @escaping (Error) -> Void = {_ in },
        started: @escaping (GKTurnBasedMatch) -> Void = {_ in }
    ) {
        self.request = request
        self.cancelled = cancelled
        self.failed = failed
        self.started = started
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MatchMakerView>) -> GKTurnBasedMatchmakerViewController {
        let gkRequest = GKMatchRequest()
        gkRequest.minPlayers = 2
        gkRequest.maxPlayers = 2
        gkRequest.defaultNumberOfPlayers = 2
        gkRequest.inviteMessage = "Play Reversi"
        gkRequest.playerGroup = self.request.toInt()
        
        let matchmakerViewController = GKTurnBasedMatchmakerViewController(matchRequest: gkRequest)
        matchmakerViewController.turnBasedMatchmakerDelegate = context.coordinator
        return matchmakerViewController
    }
    
    func updateUIViewController(_ uiViewController: GameManagerController, context: UIViewControllerRepresentableContext<GameManagerView>) { }
    func updateUIViewController(_ uiViewController: GKTurnBasedMatchmakerViewController, context: Context) { }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, GKTurnBasedMatchmakerViewControllerDelegate, GKMatchDelegate {
        
        let parent: MatchMakerView
        
        init(_ parent: MatchMakerView) {
            self.parent = parent
        }
        
        func turnBasedMatchmakerViewControllerWasCancelled(_ viewController: GKTurnBasedMatchmakerViewController) {
            viewController.dismiss(
                animated: true,
                completion: {
                    self.parent.cancelled()
                    viewController.removeFromParent()
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            )
        }
        
        func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: Error) {
            viewController.dismiss(
                animated: true,
                completion: {
                    self.parent.failed(error)
                    viewController.removeFromParent()
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            )
        }
        
        func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKTurnBasedMatch) {
            viewController.dismiss(
                animated: true,
                completion: {
                    self.parent.started(match)
                    viewController.removeFromParent()
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}
