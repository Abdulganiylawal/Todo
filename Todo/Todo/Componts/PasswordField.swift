//
//  PasswordField.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 18/09/2023.
//

import Foundation
import SwiftUI

struct PasswordField: View {
    var placeholder: String
    @Binding var text: String
    @Binding var isSecure: Bool

    var body: some View {
        HStack {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }

            Button(action: {
                isSecure.toggle()
            }) {
                Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.gray)
            }
        }
    }
}


