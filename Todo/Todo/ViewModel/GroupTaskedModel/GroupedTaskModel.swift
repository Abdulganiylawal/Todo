//
//  GroupedTaskModel.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 04/02/2024.
//

import Foundation
import CoreData
import SwiftUI





class Grouping{
  
    
    func groupByTimeOfDay(for remainder:CDRemainder) -> String {
        let date = DateFormatterModel.shared.stringTimeToDate(remainder.schedule_!.time, isTime: true)
//        print(date)
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
//        print(hour)
        if hour >= 12 && hour < 18 {
            return "Afternoon"
        } else if hour >= 18 {
            return "Night"
        } else {
            return "Morning"
        }
    }
    
    func groupByName(remainder:CDRemainder) -> String{
        return remainder.list!.name_!
    }
    
    func groupByMonth(for remainder: CDRemainder) -> String {
        let date = DateFormatterModel.shared.stringTimeToDate(remainder.schedule_!.date, isTime: false)
        
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        print(month)
        switch month {
        case 1: return "January"
        case 2: return "February"
        case 3: return "March"
        case 4: return "April"
        case 5: return "May"
        case 6: return "June"
        case 7: return "July"
        case 8: return "August"
        case 9: return "September"
        case 10: return "October"
        case 11: return "November"
        case 12: return "December"
        default: return "Unknown Month"
        }
    }

}
