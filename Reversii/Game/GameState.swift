//
//  GameState.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 10/10/21.
//

import Foundation
import SwiftUI

struct GameState: Codable {
    var boardSize: Int = 8
    var pieces: [Pieces?]
    var playerTurn: Pieces
    var isGameOver: Bool
    var score: GameScore
    
    private var onMove: (GameState) -> Void = {_ in}
    
    private enum CodingKeys : String, CodingKey {
        case pieces
        case playerTurn
        case isGameOver
        case score
    }
    
    private static let _movements: [Cord] = [
        Cord(x:1,y:0),
        Cord(x:-1,y:0),
        Cord(x:0,y:-1),
        Cord(x:0,y:1),
        Cord(x:1,y:-1),
        Cord(x:1,y:1),
        Cord(x:-1,y:-1),
        Cord(x:-1,y:1)
    ]
    
    init() {
        self.pieces = GameState.initialBoard(size: boardSize)
        self.playerTurn = .white
        self.isGameOver = false
        self.score = GameScore(white: 2, black: 2)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.pieces = try values.decode([Pieces?].self, forKey: .pieces)
        self.playerTurn = try values.decode(Pieces.self, forKey: .playerTurn)
        self.isGameOver = try values.decode(Bool.self, forKey: .isGameOver)
        self.score = try values.decode(GameScore.self, forKey: .score)
    }
    
    private init(pieces: [Pieces?], playerTurn: Pieces, isGameOver: Bool, score: GameScore) {
        self.pieces = pieces
        self.playerTurn = playerTurn
        self.isGameOver = isGameOver
        self.score = score
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
    
    func moveFlips(
        position: Position,
        piece: Pieces? = nil
    ) -> Set<Position> {
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
        
        self.onMove(self)
        
        return true
    }
    
    mutating func registerOnMove(onMoveDelegate: @escaping (GameState) -> Void) {
        self.onMove = onMoveDelegate
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
        var white: UInt64
        var black: UInt64
    }
    
    func encode() throws -> Data {
        var misc: UInt64 = 0
        var white: UInt64 = 0
        var black: UInt64 = 0
        
        misc |= (self.isGameOver ? 1 : 0)
        misc |= (self.playerTurn == Pieces.white ? 0 : 1) << 1
        
        for index in 0...63 {
            white |= (self.pieces[index] == Pieces.white ? 1 : 0) << index
            black |= (self.pieces[index] == Pieces.black ? 1 : 0) << index
        }
        
        return withUnsafeBytes(of: [misc, self.score.white, self.score.black, white, black]) { Data($0) }
    }
    
    static func decode(_ data: Data) throws -> GameState {
        var values = Array<UInt64>(repeating: 0, count: 5)
        if (data.count != values.count * UInt64.bitWidth) {
            throw DecodingError()
        }
        _ = values.withUnsafeMutableBytes { data.copyBytes(to: $0 ) }
        
        let misc = values[0]
        let whiteScore = values[1]
        let blackScore = values[2]
        let white = values[3]
        let black = values[4]
        
        var pieces:[Pieces?] = Array(repeating: nil, count: 64)
        
        for index in 0...64 {
            if ((white >> index) & 1 == 1) {
                pieces[index] = Pieces.white
            }
            else if ((black >> index) & 1 == 1) {
                pieces[index] = Pieces.black
            }
        }
        
        return GameState(
            pieces: pieces,
            playerTurn: misc >> 1 & 1 == 1 ? Pieces.white : Pieces.black,
            isGameOver: misc >> 0 & 1 == 1,
            score: GameScore(white: whiteScore, black: blackScore)
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.pieces, forKey: .pieces)
        try container.encode(self.playerTurn, forKey: .playerTurn)
        try container.encode(self.isGameOver, forKey: .isGameOver)
        try container.encode(self.score, forKey: .score)
    }
    
    class DecodingError : Error {
        
    }
}
