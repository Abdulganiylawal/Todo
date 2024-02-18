//
//  Styles.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 19/09/2023.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        
        if let rgbValue = UInt32(hex, radix: 16) {
            let r = Double((rgbValue & 0xFF0000) >> 16) / 255
            let g = Double((rgbValue & 0x00FF00) >> 8) / 255
            let b = Double(rgbValue & 0x0000FF) / 255
            self.init(red: r, green: g, blue: b)
        } else {
       
            self.init(red: 0, green: 0, blue: 0)
        }
    }
}

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
                   insertion: .move(edge: .trailing).combined(with: .opacity),
                   removal: .move(edge: .leading).combined(with: .opacity)
               )
    }
    static var move: AnyTransition {
        .asymmetric(
                   insertion: .move(edge: .bottom).combined(with: .opacity),
                   removal: .move(edge: .leading).combined(with: .opacity)
               )
    }
}

