//
//  ListTest.swift
//  TodoTests
//
//  Created by Lawal Abdulganiy on 13/11/2023.
//

import XCTest
import CoreData
@testable import Todo

final class ListTest: XCTestCase {
    
    private var modelTest:ListViewManger!
    var context:NSManagedObjectContext!

    
    override func setUpWithError() throws {
        modelTest = ListViewManger(context: PersistenceController.Testing.container.newBackgroundContext())
        context =  PersistenceController.Testing.container.newBackgroundContext()
        
        
    }

    override func tearDownWithError() throws {
        context = nil
        modelTest = nil
 
    }

    func testListHasAValueWhenAddedTo(){
        modelTest.addList(name: "Testing", image: "list.bullet", color: "#a28089")
        XCTAssert(modelTest.myList.count == 1, "Theu should be an element in  mylist")
    }
    
    func testListShouldBeEmptyWhenDeleted(){
        let list = CDList(name: "Testing", color: "#a28089", image: "list.bullet", context: context)
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
                return true
            }
            do{
              try context.save()
            }catch{
                print(error.localizedDescription)
            }
        waitForExpectations(timeout: 2.0) { error in
                XCTAssertNil(error, "Save did not occur")
            }
        
        CDList.delete(list: list)
        let request = CDList.fetchRequest()
        request.predicate = NSPredicate.all
        let result = try? context.fetch(request)
        XCTAssertTrue(result!.isEmpty, "The result should be empty")
    }
    
    

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
