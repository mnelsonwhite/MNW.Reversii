//
//  GameState.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 10/10/21.
//

import Foundation
import SwiftUI

class GameState: ObservableObject {
    @Published var size: Int
    @Published var pieces: [Pieces?]
    @Published var turn: Pieces = .white
    @Published var isGameOver: Bool = false
    
    private let _movements: [(Int, Int)] = [(1,0), (-1,0), (0,-1), (0,1), (1,-1), (1,1), (-1,-1), (-1,1)]
    
    init(size: Int = 8) {
        self.size = size
        self.pieces = GameState.initialBoard(size: size)
    }
    
    func validMoves(piece: Pieces? = nil) -> Set<Position> {
        var moves = Set<Position>()
        for ord in 0...self.pieces.count - 1 {
            let position = Position(ordinal: ord, size: self.size)
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
        _movements.forEach { movement in
            tempFlips.removeAll()
            for tryPos in position.getLine(movement: movement) {
                if !tryPos.isValid() ||
                    self.pieces[tryPos.ordinal] == nil ||
                    tempFlips.count == 0 &&
                    self.pieces[tryPos.ordinal] == piece ?? self.turn {

                    break;
                }
                else if tempFlips.count > 0 && self.pieces[tryPos.ordinal] == piece ?? self.turn {
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
    
    func tryPmove(position: Position) -> Bool {
        let flips = self.moveFlips(position: position)
        
        if flips.isEmpty {
            return false
        }
        
        self.pieces[position.ordinal] = self.turn
        for flip in flips {
            self.pieces[flip.ordinal] = self.turn
        }
        
        let opponentPiece: Pieces = self.turn == .white ? .black : .white
        let currentHasNoMoves = self.validMoves(piece: self.turn).isEmpty
        let opponentHasNoMoves = self.validMoves(piece: opponentPiece).isEmpty
        
        self.turn = opponentHasNoMoves ? self.turn : opponentPiece
        self.isGameOver = currentHasNoMoves && opponentHasNoMoves
        
        return true
    }
    
    func reset() {
        self.pieces = GameState.initialBoard(size: self.size)
        self.isGameOver = false
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
}
