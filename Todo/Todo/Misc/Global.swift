//
//  Global.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 25/09/2023.
//

import Foundation
import SwiftUI

class AppColorScheme {
    static let shared = AppColorScheme()
    @Environment(\.colorScheme) var colorScheme: SwiftUI.ColorScheme
}

