//
//  RemainderModel.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import Foundation

class RemainderManager:ObservableObject{
    @Published var title:String = ""
    @Published var description:String = ""
    @Published var isComplete:Bool = false
    var model = ListModel(name: "", image: "", color: "")
    
    
    func addRemainder(model:ListModel){
        self.model = model
        self.model.remainders.append(RemainderModel(title: "Lawal", description: "yes"))
        print(model.remainders)
    }
}
