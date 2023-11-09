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
    
    func delete(list: CDList) async {
        guard let context = list.managedObjectContext else { return }
        
        for remainder in list.remainders {
            CDRemainder.delete(remainder: remainder)
        }
        
        context.delete(list)
        await PersistenceController.shared.save()
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


