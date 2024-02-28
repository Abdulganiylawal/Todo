//
//  Modifiers.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 07/11/2023.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - placeholder for textfield

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



// MARK: -
extension View {
    @ViewBuilder
    func   hiddenNavBar(_ isHidden: Bool )->some View{
        self.modifier(NavBarModifier(isHidden: isHidden))
    }
}

private struct NavBarModifier:ViewModifier{
    var isHidden:Bool
    func body(content: Content) -> some View {
        content
            .background(NavigationControllerExtractor(isHidden: isHidden  ))
    }
}


private struct NavigationControllerExtractor: UIViewRepresentable {
    var isHidden: Bool
    func makeUIView(context: Context) -> UIView {
    return UIView()
}
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if let hostView = uiView.superview?.superview, let parentController = hostView.parentController {
                parentController.navigationController?.hidesBarsOnSwipe = true
            }

        }
    }
}

private extension UIView
{
    var parentController: UIViewController? {
        sequence (first: self) { view in
            view.next
        }
        .first { responder in
                return responder is UIViewController
            }      as? UIViewController

        }
}
