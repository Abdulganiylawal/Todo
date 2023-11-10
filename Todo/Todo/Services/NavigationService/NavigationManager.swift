//
//  NavigationManager.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 10/11/2023.
//

import Foundation


final class NavigationManager:ObservableObject{
    @Published var routes = [Route]()
    
    func push(to screen:Route){
        guard !routes.contains(screen) else {return}
        routes.append(screen)
    }
    
    func goBack(){
        _ = routes.popLast()
    }
    
    func reset() {
        routes = []
    }
}
