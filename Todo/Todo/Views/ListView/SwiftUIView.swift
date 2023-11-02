//
//  SwiftUIView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 02/11/2023.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        Image(systemName: "house")
            .symbolRenderingMode(.hierarchical)
            .foregroundColor(.indigo)
        
        Image(systemName: "square.stack.3d.down.right.fill")
            .symbolRenderingMode(.hierarchical)
            .foregroundColor(.indigo)
           
    }
}

#Preview {
    SwiftUIView()
}
