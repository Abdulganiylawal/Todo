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
    
    var remainders:Set<CDRemainder>{
        get{
            (remainders_ as? Set<CDRemainder>) ?? []
        }
        set{
            remainders_ = newValue as NSSet
        }
    }
    
    static func delete(list: CDList){
        guard let context = list.managedObjectContext else { return }
        
        for remainder in list.remainders {
            CDRemainder.delete(remainder: remainder)
        }
        context.delete(list)
        Task{
            await PersistenceController.shared.save()
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
    
    
}
