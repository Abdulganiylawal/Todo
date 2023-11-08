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
    var colors:String
    
    
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color(hex: colors)).opacity(colorScheme == .dark ? 0.6 : 0.2)
                .blendMode(.overlay)
        )
    }
}

@available(iOS 17.0, *)
struct BackgroundColor: ViewModifier {
    var opacity: Double = 0.6
    @Environment(\.colorScheme) var colorScheme
    var color:String
    func body(content: Content) -> some View {
        content
            .overlay(
                Color(Color(hex: color))
                    .opacity(colorScheme == .dark ? opacity : 0.3)
                    .blendMode(.overlay)
                  
            )
    }
}

@available(iOS 17.0, *)
extension View {
    func backgroundColor(opacity: Double = 0.6,color:String) -> some View {
        self.modifier(BackgroundColor(opacity: opacity, color: color))
    }
}

@available(iOS 17.0, *)
struct BackgroundStyle: ViewModifier {
    var cornerRadius: CGFloat = 20
    var opacity: Double = 0
    var colors:String
   
    
    func body(content: Content) -> some View {
        content
            .backgroundColor(opacity: opacity, color: colors)
            .cornerRadius(cornerRadius)
            .modifier(OutlineOverlay(cornerRadius: cornerRadius, colors: colors))
    }
}

@available(iOS 17.0, *)
extension View {
    func backgroundStyle(cornerRadius: CGFloat = 20, opacity: Double = 1,colors:String) -> some View {
        self.modifier(BackgroundStyle(cornerRadius: cornerRadius, opacity: opacity, colors: colors))
    }
}

@available(iOS 17.0, *)
extension View {
    @ViewBuilder
    func customBackground(condition: Bool, color: String) -> some View {
        if condition {
            background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(colors: [Color(hex: color).opacity(0.3), Color(UIColor.black).opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
                
            )
        }else{
            background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(colors: [Color(hex: color).opacity(0.2), Color(hex: color).opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
                
            )
            .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x: 0, y: 10)
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
