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
    public var context:NSManagedObjectContext
    @AppStorage("showAuthView") private var showAuthView = false
    
    var body: some View {
        NavigationStack {
                 if showAuthView {
                     Authiew()
                 } else {
                     MainView(context:context)
                 }
        }.onAppear {
            showAuthView = Auth.auth().currentUser?.uid == nil
        }

    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(context: PersistenceController.shared.container.viewContext)
    }
}
