//
//  Modifiers.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 07/11/2023.
//

import Foundation
import SwiftUI
struct OutlineOverlay: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var cornerRadius: CGFloat = 20
    
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    .linearGradient(
                        colors: [
                            .white.opacity(colorScheme == .dark ? 0.6 : 0.3),
                            .black.opacity(colorScheme == .dark ? 0.3 : 0.1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom)
                )
                .blendMode(.overlay)
        )
    }
}

@available(iOS 17.0, *)
struct BackgroundColor: ViewModifier {
    var opacity: Double = 0.6
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Color(Color(hex: "ADC4CE"))
                    .opacity(colorScheme == .dark ? opacity : 0)
                    .blendMode(.overlay)
                    .allowsHitTesting(false)
            )
    }
}

@available(iOS 17.0, *)
extension View {
    func backgroundColor(opacity: Double = 0.6) -> some View {
        self.modifier(BackgroundColor(opacity: opacity))
    }
}

@available(iOS 17.0, *)
struct BackgroundStyle: ViewModifier {
    var cornerRadius: CGFloat = 20
    var opacity: Double = 0
    @AppStorage("isLiteMode") var isLiteMode = true
    
    func body(content: Content) -> some View {
        content
            .backgroundColor(opacity: opacity)
            .cornerRadius(cornerRadius)
            
            .modifier(OutlineOverlay(cornerRadius: cornerRadius))
    }
}

@available(iOS 17.0, *)
extension View {
    func backgroundStyle(cornerRadius: CGFloat = 20, opacity: Double = 1) -> some View {
        self.modifier(BackgroundStyle(cornerRadius: cornerRadius, opacity: opacity))
    }
}

@available(iOS 17.0, *)
extension View {
    @ViewBuilder
    func customBackground(condition: Bool, color: String) -> some View {
        if condition {
            background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(colors: [Color(hex: color).opacity(0.2), Color(hex: color).opacity(0.2)], startPoint: .top, endPoint: .bottomLeading))
            )
        }else{
            self
        }
    }
}
