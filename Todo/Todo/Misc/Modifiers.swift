//
//  Modifiers.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 07/11/2023.
//

import Foundation
import SwiftUI

// MARK: - Use this for the main ui
struct OutlineOverlay: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var cornerRadius: CGFloat = 20
    var colors:String
    
    
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color(hex: colors)).opacity( 1 )
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
                    .opacity(opacity)
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
    func customBackground(colorScheme:ColorScheme, color: String) -> some View {
        background(
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(colors: [Color(hex: color).opacity(0.6), Color(UIColor.black).opacity(0.3) ], startPoint: .topLeading, endPoint: .trailing ))
        )
      
    }
    
    @ViewBuilder
    func customBackgroundForRemainderRow(colorscheme:ColorScheme, color: String) -> some View {
        
        background(
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(colors: [Color(hex: color).opacity(0.3),Color(hex: color).opacity(0.2), Color(hex: color).opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing))
        )
    
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment ,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct BackButtonModifier: ViewModifier {
    @ObservedObject var navigationState:NavigationManager
    var color:String
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(action: {
                        navigationState.reset()
                    }, color: color)
                }
            }
    }
}

extension View {
    func withCustomBackButton(state:NavigationManager , color:String = "0802A3") -> some View {
        modifier(BackButtonModifier(navigationState: state, color: color))
    }
}

// MARK: - Going to be using this for buttons
struct OutlineOverlay1: ViewModifier {
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
   }}


struct BackgroundColor1: ViewModifier {
   var opacity: Double = 0.6
   @Environment(\.colorScheme) var colorScheme
   
   func body(content: Content) -> some View {
       content
           .overlay(
               Color("Background")
                   .opacity(colorScheme == .dark ? opacity : 0)
                   .blendMode(.overlay)
                   .allowsHitTesting(false)
           )
   }
}

extension View {
   func backgroundColor1(opacity: Double = 0.6) -> some View {
       self.modifier(BackgroundColor1(opacity: opacity))
   }
}

struct BackgroundStyle1: ViewModifier {
   var cornerRadius: CGFloat = 20
   var opacity: Double = 0.6
   @AppStorage("isLiteMode") var isLiteMode = true
   
   func body(content: Content) -> some View {
       content
           .backgroundColor1(opacity: opacity)
           .cornerRadius(cornerRadius)
           .modifier(OutlineOverlay1(cornerRadius: cornerRadius))
   }
}

extension View {
   func backgroundStyle1(cornerRadius: CGFloat = 20, opacity: Double = 0.6) -> some View {
       self.modifier(BackgroundStyle1(cornerRadius: cornerRadius, opacity: opacity))
   }
}
