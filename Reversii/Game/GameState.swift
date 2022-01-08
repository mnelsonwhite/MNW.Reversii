//
//  GameState.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 10/10/21.
//

import Foundation
import SwiftUI

struct GameState: Codable {
    let startTime: Date
    let clockDuration: TimeInterval?
    let boardSize: Int

    var pieces: [Pieces?]
    var playerTurn: Pieces
    var isGameOver: Bool
    var score: GameScore
    var playerClock: PlayerClock?
    
    var whitePlayerId: String?
    var blackPlayerId: String?
    
    private static let _movements: [Cord] = [
        Cord(x:1,y:0),
        Cord(x:-1,y:0),
        Cord(x:0,y:-1),
        Cord(x:0,y:1),
        Cord(x:1,y:-1),
        Cord(x:1,y:1),
        Cord(x:-1,y:-1),
        Cord(x:-1,y:1)]
    
    init(
        boardSize: Int = 8,
        startTime: Date = Date(),
        clockDuration: TimeInterval? = nil,
        whitePlayerId: String? = nil,
        blackPlayerId: String? = nil
    ) {
        self.startTime = startTime
        self.clockDuration = clockDuration
        self.boardSize = boardSize

        self.pieces = GameState.initialBoard(size: boardSize)
        self.playerTurn = .white
        self.isGameOver = false
        self.score = GameScore(white: 2, black: 2)
        self.playerClock = clockDuration == nil ? nil : PlayerClock(white: clockDuration!, black: clockDuration!)
        
        self.whitePlayerId = whitePlayerId
        self.blackPlayerId = blackPlayerId
    }
    
    func validMoves(piece: Pieces? = nil) -> Set<Position> {
        var moves = Set<Position>()
        for ord in 0...self.pieces.count - 1 {
            let position = Position(ordinal: ord, size: self.boardSize)
            if !self.moveFlips(position: position, piece: piece).isEmpty {
                moves.insert(position)
            }
        }
        
        return moves
    }
    
    func moveFlips(position: Position, piece: Pieces? = nil) -> Set<Position> {
        var flips = Set<Position>()

        if !position.isValid() || self.pieces[position.ordinal] != nil {
            return flips
        }
        
        var tempFlips = Set<Position>()
        GameState._movements.forEach { movement in
            tempFlips.removeAll()
            for tryPos in position.getLine(movement: movement) {
                if !tryPos.isValid() ||
                    self.pieces[tryPos.ordinal] == nil ||
                    tempFlips.count == 0 &&
                    self.pieces[tryPos.ordinal] == piece ?? self.playerTurn {

                    break;
                }
                else if tempFlips.count > 0 && self.pieces[tryPos.ordinal] == piece ?? self.playerTurn {
                    flips = flips.union(tempFlips)
                    break;
                }
                else {
                    tempFlips.insert(tryPos)
                }
            }
        }
        
        return flips
    }
    
    mutating func tryPmove(position: Position) -> Bool {
        let flips = self.moveFlips(position: position)
        
        if flips.isEmpty {
            return false
        }
        
        self.pieces[position.ordinal] = self.playerTurn
        for flip in flips {
            self.pieces[flip.ordinal] = self.playerTurn
        }
        
        let opponentPiece: Pieces = self.playerTurn == .white ? .black : .white
        let currentHasNoMoves = self.validMoves(piece: self.playerTurn).isEmpty
        let opponentHasNoMoves = self.validMoves(piece: opponentPiece).isEmpty
        
        self.playerTurn = opponentHasNoMoves ? self.playerTurn : opponentPiece
        self.isGameOver = currentHasNoMoves && opponentHasNoMoves
        self.score = self.getScore()
        
        return true
    }
    
    private func getScore() -> GameScore {
        var pieces = GameScore(white: 0, black: 0)

        for piece in self.pieces {
            if piece == .white {
                pieces.white += 1
            }
            else if piece == .black {
                pieces.black += 1
            }
        }
        
        return pieces
    }
    
    private static func initialBoard(size: Int) -> [Pieces?] {
        var pieces: [Pieces?] = Array(repeating: nil, count: size * size)
        let half = size / 2
        
        pieces[Position(x: half, y: half, size: size).ordinal] = .white
        pieces[Position(x: half, y: half + 1, size: size).ordinal] = .black
        pieces[Position(x: half + 1, y: half, size: size).ordinal] = .black
        pieces[Position(x: half + 1, y: half + 1, size: size).ordinal] = .white
        
        return pieces
    }
    
    private static func getRandomPiece() -> Pieces {
        return Int.random(in: 0...1) == 0 ? .white : .black
    }
    
    struct GameScore: Codable {
        var white: Int
        var black: Int
    }
    
    struct PlayerClock: Codable {
        var white: TimeInterval
        var black: TimeInterval
    }
    
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
    
    static func decode(_ data: Data) throws -> GameState {
        let decoder = JSONDecoder()
        return try decoder.decode(GameState.self, from: data)
    }
}
