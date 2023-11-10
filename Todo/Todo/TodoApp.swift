//
//  TodoApp.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 16/09/2023.
//

import SwiftUI



class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
  
        
        return true
    }
}

@available(iOS 17.0, *)
@main
struct TodoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @Environment(\.scenePhase) var scenePhase
    
    let persistenceController = PersistenceController.shared
    @StateObject var navigationManager = NavigationManager()
    @StateObject var sheetManager = SheetManager()
    
    var body: some Scene {
        WindowGroup {
            Home(context: persistenceController.container.viewContext)
    
                .preferredColorScheme(.dark)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(sheetManager)
                .environmentObject(navigationManager)
                .onChange(of: scenePhase) { oldValue , newValue in
                    if newValue == .background{
                        Task{
                            await persistenceController.save()
                        }
                    }
                }
        }
    }
}
