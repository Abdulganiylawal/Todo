//
//  DateFormatter.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 08/11/2023.
//

import Foundation
import SwiftUI
import UIKit

class DateFormatterModel{
  
 
  func formattedDatesString(from component: Date,isTime:Bool) -> String {
        let dateFormatter = DateFormatter()
        if isTime{
            dateFormatter.dateFormat = "HH:mm"
        }
        else{
            dateFormatter.dateFormat = "dd/MM/yyyy"
        }
        let dateComponents = component
        let formattedDates = dateFormatter.string(from: dateComponents)
        return formattedDates
    }

    func timeDifference(from startTime: String, to endTime: String) -> Double? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone.current

        guard let start = dateFormatter.date(from: startTime),
              let end = dateFormatter.date(from: endTime) else {
            return nil
        }
        
        // If the end time is before the start time, assume it's on the next day
        let adjustedEnd = end < start ? Calendar.current.date(byAdding: .day, value: 1, to: end)! : end

        let difference = Calendar.current.dateComponents([.second], from: start, to: adjustedEnd)

        // Return the difference in seconds
      
        return Double(difference.second ?? 0)
    }


 


}
