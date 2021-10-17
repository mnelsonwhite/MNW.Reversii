//
//  Move.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 12/10/21.
//

import Foundation

struct Move: Codable {
    let gameId: UUID
    let position: Position
    let duration: TimeInterval
    let player: Pieces
}
