//
//  RemainderModel.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import Foundation
import Combine

class RemainderManager:ObservableObject{
    @Published var model:ListModel
//    @Published var remainders:Set<[RemainderModel]> = []
//    @Published var CompletedRemainders:Set<[RemainderModel]> = []
    @Published var remainder:RemainderModel = RemainderModel(title: "", description: "", schedule: "")
    
    init(model: ListModel) {
        self.model = model
        print(model.remainders)
//        getRemainders()
    }
    
//    func getRemainders(){
//        for remainders in model.remainders{
//            self.remainders += Set<remainders>
//        }
//        print(self.remainders)
//    }
    
    func addRemainder(){
       
    }
    
    func saveRemainder(){
        model.remainders.append(remainder)
    }
}
