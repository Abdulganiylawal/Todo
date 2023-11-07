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
import CoreData

class ListViewManger:ObservableObject{
    @Published var myList = [CDList]()
    @Published var title = ""
    @Published var isEnabled: Bool = false
    var context:NSManagedObjectContext

    func addList(name:String,image:String,color:String){
        myList.append(CDList(name: name, color: color, image: image, context: context))
    }
    

    func fetchList() {
        let request = CDList.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDList.name_, ascending: true)]
        request.predicate = NSPredicate.all
        do{
          let result =  try context.fetch(request)
          myList = result
        }catch{
            print("\(error)")
        }
       
    }
    
    func delete(list: CDList) {
        guard let context = list.managedObjectContext else { return }
        
        for remainder in list.remainders {
            CDRemainder.delete(remainder: remainder)
        }
        
        context.delete(list)
        PersistenceController.shared.save()
    }

   
    init(context: NSManagedObjectContext){
        self.context = context
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

