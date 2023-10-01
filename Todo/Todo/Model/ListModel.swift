//
//  ListModel.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 25/09/2023.
//

import Foundation
import UIKit

struct ListModel:Identifiable{
    var id = UUID()
    let name:String
    let image:String
    let color:String
    var remainders: [RemainderModel] = []
    var completedRemainders:[RemainderModel] = []
    
    mutating func addRemainder(){
        remainders.append(RemainderModel(title: "", description: "", schedule: ""))
    }
    
    mutating func addCompletedRemainders(_ remainder: RemainderModel) {
        completedRemainders.append(remainder)
    }
    
    mutating func removeRemainder(_ remainder: RemainderModel) {
        if let index = remainders.firstIndex(where: { $0.id == remainder.id }),
            remainders.indices.contains(index) {
            print(index)
            if let element = remainders[safe: index] {
                print("Removing: \(element)")
                remainders.remove(at: index)
            } else {
                print("Index out of range.")
            }
        } else {
            print("Remainder not found in the list.")
        }
    }

}

extension Collection where Indices.Iterator.Element == Index {
    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

