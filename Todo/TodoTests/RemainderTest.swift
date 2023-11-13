//
//  RemainderTest.swift
//  TodoTests
//
//  Created by Lawal Abdulganiy on 13/11/2023.
//

import XCTest
import CoreData

@testable import Todo
final class RemainderTest: XCTestCase {
    
    var context:NSManagedObjectContext!
    var dateFormatter:DateFormatterModel!
   
    
    override func setUpWithError() throws {
        context = PersistenceController.Testing.container.newBackgroundContext()
        dateFormatter = DateFormatterModel()
    }
    
    override func tearDownWithError() throws {
        context = nil
        dateFormatter = nil
    }
    
    func testCDRemainderShouldHaveAValueWhenAddedACDRemainderObject(){
        let list = CDList(name: "Testing", color: "#a28089", image: "list.bullet", context: context)
        let remainder = CDRemainder(context: context, title: "Testing", notes: "Testing")
        remainder.list = list
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context){ _ in
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
        
        let request = CDRemainder.fetchRequest()
        request.predicate = NSPredicate.all
        let result = try? context.fetch(request)
        XCTAssertTrue(!result!.isEmpty, "The result mush have a value")
    }
    
    func testCDRemainderShouldBeEmptyWhenAnObjectIsDeleted(){
        let list = CDList(name: "Testing", color: "#a28089", image: "list.bullet", context: context)
        let remainder = CDRemainder(context: context, title: "Testing", notes: "Testing")
        remainder.list = list
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context){ _ in
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
        CDRemainder.delete(remainder: remainder)
        let request = CDRemainder.fetchRequest()
        request.predicate = NSPredicate.all
        let result = try? context.fetch(request)
        XCTAssertTrue(result!.isEmpty, "The result should be empty")
    }
    
    func testForDurationTimeWhenCallingAFunctionThatTakesTwoTimeStringAndCalculateTheDurationTime(){
        let date = Date()
        let startTime = dateFormatter.formattedDatesString(from: date, isTime: true)
        let twoHrsLater = Calendar.current.date(byAdding: .minute, value: 2, to: date)!
        let endTime = dateFormatter.formattedDatesString(from: twoHrsLater , isTime: true)
        let durationTime = dateFormatter.timeDifference(from: startTime, to: endTime)
        XCTAssertNotNil(durationTime)
        XCTAssertEqual(durationTime, 120)
    }
        
        
        func testPerformanceExample() throws {
            // This is an example of a performance test case.
            self.measure {
                // Put the code you want to measure the time of here.
            }
        }
        
    
}
