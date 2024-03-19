//
//  RoutingModel.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 10/11/2023.
//

import Foundation
import CoreData
import SwiftUI

enum Route{
    case remainderView(model:CDList)
    case SettingsView
    case searchView(context:NSManagedObjectContext)
    case groupTaskView(selector:TaskGroup,context:NSManagedObjectContext)
    case ChatAssistantView
}

extension Route:Hashable{
    func hash(into hasher: inout Hasher) {
           hasher.combine(self.hashValue)
       }
    
    static func == (lhs:Route,rhs:Route) -> Bool{
        switch (lhs, rhs){
                
            case (.remainderView(let lhs),.remainderView(let rhs)):
                return lhs.objectID == rhs.objectID
                
            case (.searchView(let lhs),.searchView(let rhs)):
                return lhs == rhs
            
            case (.SettingsView,.SettingsView):
                return true
                
            case (.groupTaskView(selector:let lhs),.groupTaskView(selector: let rhs)):
                return lhs == rhs
            case (.ChatAssistantView,.ChatAssistantView):
                return true
            default:
                return false
        }
    }
}

@available(iOS 17.0, *)
extension Route:View{
     var body: some View{
        switch self {
            case .remainderView(let model):
                RemainderView(model: model)
//                    .withCustomBackButton(state: state, color: model.color)
            case .SettingsView:
                Settings()
//                    .withCustomBackButton(state: state)
            case .searchView(let context):
                SearchView(context: context)
//                    .withCustomBackButton(state: state)
            case .groupTaskView(selector: let selector,context:let context):
                GroupedTaskView(selector: selector,context: context)
                
            case .ChatAssistantView:
                ChatAssistant()
        }
    }
}
