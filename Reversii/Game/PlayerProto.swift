//
//  OpponentProto.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 12/10/21.
//

import Foundation
import Combine

protocol PlayerProto {
    func requestMove(move: Move) -> Future<Move,Error>
}
