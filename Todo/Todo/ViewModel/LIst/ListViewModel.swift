//
//  ListViewModel.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 25/09/2023.
//

import Foundation
import UIKit
import SwiftUI
import Combine

class ListViewManger:ObservableObject{
    @Published var myList = [ListModel]()
    @Published var title = ""
    @Published var isEnabled: Bool = false
    var imageName:String = ""
    var colorName:String = ""

    func addList(name:String,image:String,color:String){
        myList.append(ListModel(name: name, image: image, color: color))
    }
    
   
    init(){
        isClickable
            .assign(to: &$isEnabled)
    }

    lazy var isClickable: AnyPublisher<Bool,Never> = {
        $title
            .map { value in
                return value.count >= 1
            }.eraseToAnyPublisher()
    }()
}

let popularColors: [String] = [
    "D83F31",
    "618264",
    "0C356A",
    "FEBF63",
    "5B0888",
    "FE7BE5",
    "F4E869",
    "419197",
    "65647C",
    "4F200D",
    "A1CCD1",
    "252B48",
    "116D6E",
    "FFF7D4",
    "AE445A",
    "435334",
    "5C5470",
    "7EAA92",
    "625757",
]

let todoIcons: [String] = [
    "list.bullet",           // A simple bullet list
    "checkmark.circle",      // A checkmark inside a circle
    "square.and.pencil",     // A square with a pencil
    "doc.text",              // A document or note
    "calendar",              // A calendar
    "flag",                  // A flag for marking important tasks
    "bookmark",              // A bookmark
    "tray",                  // A tray or in-tray for tasks
    "tag",                   // A tag for categorizing tasks
    "arrow.right.circle",    // A right-facing arrow inside a circle
    "book",                  // A book for reference or reading
    "clock",                 // A clock for time-sensitive tasks
    "person",                // A person for assignments or responsibilities
    "star",                  // A star for highlighting important tasks
    "paperplane",            // A paper airplane for sharing tasks
    "folder",                // A folder for organizing tasks
    "pencil",                // A pencil for editing or adding tasks
    "checkmark.rectangle",   // A checkmark inside a rectangle
]

let listModels: [ListModel] = Array(repeating: ListModel(name: "Your List Name", image: "list.bullet", color: "D83F31"), count: 2)
