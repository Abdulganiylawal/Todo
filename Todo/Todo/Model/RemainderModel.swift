//
//  RemainderModel.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import Foundation

struct RemainderModel:Identifiable {
    var id = UUID()
    var title:String
    var description:String
//    let Schedule:Date
    var isComplete = false
}
