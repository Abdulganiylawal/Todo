//
//  RemainderModel.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import Foundation

class RemainderManager:ObservableObject{
//    @Published var model:ListModel
    @Published var Remainder:[RemainderModel] = []
    
    init(model: ListModel) {
        
    }
    
}
