//
//  GameRequest\.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 5/1/2022.
//

import Foundation

struct GameOptions {
    let rated: Bool
    let voiceEnabled: Bool
    let playComputer: Bool
    let clockTime: Int
    
    
    enum ClockTimes: Int {
        case unlimited = 0
    }
    
    func toInt() -> Int {
        return
            (self.rated ? 1 : 0) |
            (self.voiceEnabled ? 1 << 1 : 0) |
            ((self.clockTime & 0b1111) << 2)
    }
    
    static func fromInt(value: Int) -> GameOptions {
        return GameOptions(
            rated: value & 1 > 0,
            voiceEnabled: value & 1 << 1 > 0,
            playComputer: value & 1 << 2 > 0,
            clockTime: (value >> 3) & 0b1111
        )
    }
}
