//
//  ListModel.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 25/09/2023.
//

import Foundation
import UIKit
import Combine

struct ListModel:Hashable,Identifiable{
    let id = UUID()
    let name:String
    let image:String
    let color:String
    var remainders: [RemainderModel] = []
    var completedRemainders:[RemainderModel] = []
    
    mutating func addRemainder(){
        remainders.append(RemainderModel(title: "", description: "", schedule: "", isComplete: false))
//        print(remainders)
    }
    
    mutating func addCompletedRemainders(item: Int) {
        completedRemainders.append(remainders.remove(at: item))
    }
    
    
   mutating func delete(item:Int){
        _ =  remainders.remove(at: item)
    }
    

}





// MARK: - Commented code will come back letter. Description removing of remainder logic

//extension Collection where Indices.Iterator.Element == Index {
//    subscript(safe index: Index) -> Iterator.Element? {
//        return indices.contains(index) ? self[index] : nil
//    }
//}

//    mutating func removeRemainder(_ remainder: RemainderModel) {
//                print(remainder)
//        var indicesToRemove: [Int] = []
//
//        for (index, element) in remainders.enumerated() {
//            if element.id == remainder.id {
//                indicesToRemove.append(index)
//                print(index,element)
//            }
//
//        }
//
//
//        for index in indicesToRemove.reversed() {
//        if let element = remainders[safe: index] {
//            print("Removing: \(element)")
//            remainders.remove(at: index)
//        } else {
//            print("Index \(index) out of range.")
//        }
//    }
////        print(remainders)
//}
//    
//    mutating func removeRemainder(withID id: UUID) {
//        if let index = remainders.firstIndex(where: { $0.id == id }) {
//            var indexesToRemove: Set<Int> = [index]
//
//            // ... determine other indexesToRemove as needed ...
//
//            let filteredRemainders = remainders.enumerated()
//                .filter { !indexesToRemove.contains($0.offset) }
//                .map { $0.element }
//
//            // Update your array with filteredRemainders
//            remainders = filteredRemainders
//        } else {
//            print("Remainder with ID \(id) not found in the list.")
//        }
//    }
