//
//  Piece.swift
//  Reversii
//
//  Created by Matthew Nelson-White on 9/10/21.
//

import SwiftUI

struct PieceView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var piece: Pieces
    
    private var fillColor: Color {
        switch self.piece {
        case .black:
            return .black
        case .white:
            return .white
        }
    
    }
    
    private var borderColor: Color {
        switch self.colorScheme {
        case.light:
            return .gray
        case.dark:
            return .gray
        default:
            return .gray
        }
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            Circle()
                .strokeBorder(self.borderColor, lineWidth: geometry.size.height * 0.03)
                .background(Circle().foregroundColor(self.fillColor))
                .rotation3DEffect(Angle.degrees(self.piece == .white ? 180 : 0), axis: (x: 0.5, y: 1, z: 0))
                .animation(.easeIn)
        }
        .scaledToFit()
    }
}

struct PieceView_Previews: PreviewProvider {
    static var previews: some View {
        PieceView(piece: .constant(.black))
    }
}
