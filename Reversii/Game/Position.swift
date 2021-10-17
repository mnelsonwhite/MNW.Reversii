//
//  Move.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 10/10/21.
//

import Foundation

struct Position: Equatable, Hashable, Codable {
    let size: Int
    let ordinal: Int
    let x: Int
    let y: Int
    
    init(ordinal: Int, size: Int = 8) {
        self.size = size
        self.ordinal = ordinal
        self.x = ordinal % size + 1
        self.y = (ordinal - ordinal % size) / size + 1
    }
    
    init(x: Int, y: Int, size: Int = 8) {
        self.size = size
        self.x = x
        self.y = y
        self.ordinal = -1 + x + (y - 1) * size
    }
    
    func isValid() -> Bool {
        return self.x >= 1 && self.x <= self.size && self.y >= 1 && self.y <= size
    }
    
    func equalTo(rhs: Position) -> Bool {
        return self.size == rhs.size && self.ordinal == rhs.ordinal
    }

    static func ==(lhs: Position, rhs: Position) -> Bool {
        return lhs.equalTo(rhs: rhs)
    }
    
    static func +(position: Position, addPosition: Cord) -> Position {
        return Position(x: position.x + addPosition.x, y: position.y + addPosition.y, size: position.size)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.ordinal)
        hasher.combine(self.size)
    }
    
    func getLine(movement: Cord) -> [Position] {
        var tryPos = self + movement
        var result: [Position] = []
        while(tryPos.isValid()) {
            result.append(tryPos)
            tryPos = tryPos + movement
        }
        
        return result
    }
}
