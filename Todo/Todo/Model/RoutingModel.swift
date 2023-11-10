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
    case SearchView
}

extension Route:Hashable{
    func hash(into hasher: inout Hasher) {
           hasher.combine(self.hashValue)
       }
    
    static func == (lhs:Route,rhs:Route) -> Bool{
        switch (lhs, rhs){
                
            case (.remainderView(let lhs),.remainderView(let rhs)):
                return lhs == rhs
                
            case (.SearchView,.SearchView):
                return true
            
            case (.SettingsView,.SettingsView):
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
            case .SearchView:
               Search()
//                    .withCustomBackButton(state: state)
        }
    }
}
