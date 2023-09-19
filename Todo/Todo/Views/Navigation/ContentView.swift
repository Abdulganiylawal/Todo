//
//  ContentView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 16/09/2023.
//

import SwiftUI
import CoreData
import FirebaseAuth
import FirebaseCore

struct ContentView: View {
    private let model = AuthenticationManager()
    @AppStorage("showAuthView") private var showAuthView = false
    
    var body: some View {
        NavigationStack {
                 if showAuthView {
                     Authiew()
                 } else {
                     MainView()
                 }
        }.onAppear {
            showAuthView = Auth.auth().currentUser?.uid == nil
        }

    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
