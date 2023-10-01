//
//  ListModel.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 25/09/2023.
//

import Foundation
import UIKit

struct ListModel:Hashable{
    var id = UUID()
    let name:String
    let image:String
    let color:String
    var remainders: [RemainderModel] = []
    var completedRemainders:[RemainderModel] = []
    
    mutating func addRemainder(){
        remainders.append(RemainderModel(id: UUID(), title: "", description: "", schedule: "", isComplete: false))
        print(remainders)
    }
    
    mutating func addCompletedRemainders(_ remaindersToAdd: [RemainderModel]) {
        completedRemainders.append(contentsOf: remaindersToAdd)
    }
    
    
    mutating func removeRemainder(_ remainder: RemainderModel) {
        
        
        //        print(remainder)
        var indicesToRemove: [Int] = []
            
        for (index, element) in remainders.enumerated() {
            if element.id == remainder.id {
                indicesToRemove.append(index)
                print(index,element)
            }
            
        }
        
        for index in indicesToRemove {
            if let element = remainders[safe: index] {
                print("Removing: \(element)")
                remainders.remove(at: index)
            } else {
                print("Index \(index) out of range.")
            }
        }
//        print(remainders)
    }

    
    
}

extension Collection where Indices.Iterator.Element == Index {
    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
