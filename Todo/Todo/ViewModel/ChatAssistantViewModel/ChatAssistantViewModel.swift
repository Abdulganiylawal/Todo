//
//  ChatAssistantViewModel.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 19/03/2024.
//

import Foundation
import CoreData

class ChatAssistantViewModel:ObservableObject{
    @Published var message:String = ""
    @Published var list:[CDList] = [CDList]()
    @Published var messages:[String] = []
    var context:NSManagedObjectContext = PersistenceController.shared.container.viewContext
    init() {
        fetchList()
    }
    
    func fetchList(){
        let request = CDList.fetch()
        do{
            list = try context.fetch(request)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func addMessage(_ message:String){
        messages.append(message)
    }
}
