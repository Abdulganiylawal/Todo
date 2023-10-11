//
//  CDList.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 11/10/2023.
//

import Foundation
import CoreData

extension CDList{
    public var id: UUID {
        return id_ ?? UUID()
    }
    
    var name:String{
        get{
            name_ ?? " "
        }set{
            name_ = newValue
        }
    }
    
    var color:String{
        get{
            color_ ?? " "
        }set{
            color_ = newValue
        }
    }
    
    var image:String{
        get{
            image_ ?? " "
        }set{
            image_ = newValue
        }
    }
    
    //    static func fetch(_ predicate:NSPredicate = .all) -> NSFetchRequest<CDList> {
    //        let request = CDList.fetchRequest()
    //        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDList.name_, ascending: true)]
    //        request.predicate = predicate
    //        return request
    //    }
    
    var remainders:Set<CDList>{
        get{
            (remainders_ as? Set<CDList>) ?? []
        }
        set{
            remainders_ = newValue as NSSet
        }
    }
    
    public override func awakeFromInsert() {
        self.id_ = UUID()
    }
    

    
    convenience init(name:String,color:String,image:String,context:NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.color = color
        self.image = image
    }
    
    static var example:CDList = {
        let context = PersistenceController.preview.container.viewContext
        let list = CDList(name: "Lawal", color: "8ECDDD", image: "calendar.badge.clock", context: context)
        
        return list
    }()
}
