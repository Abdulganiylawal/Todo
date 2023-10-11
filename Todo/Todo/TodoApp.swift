//
//  TodoApp.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 16/09/2023.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@available(iOS 17.0, *)
@main
struct YourApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(context: persistenceController.container.viewContext)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .onChange(of: scenePhase) { oldValue , newValue in
                        if newValue == .background{
                            persistenceController.save()
                        }
                    }
                
            }
        }
    }
}
