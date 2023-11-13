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
        myList.append(CDList(name: name, color: color , image: image, context: context))
    }
    
    func editList(cdList: CDList, name: String?, image: String?, color: String?) {
        guard let index = myList.firstIndex(where: { list in
            list.id == cdList.id
        }) else {
            print("Failed")
            return
        }
        var updatedList = myList[index]
        print("before = \(myList[index])")
        if let name = name {
            updatedList.name = name
        }

        if let image = image {
            updatedList.image = image
        }

        if let color = color {
            updatedList.color = color
        }
        
        DispatchQueue.main.async {
            self.myList[index] = updatedList
            self.objectWillChange.send()
        }
        print("updated = \(myList[index])")
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


