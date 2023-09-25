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
    let Counter: Int = 0
}

