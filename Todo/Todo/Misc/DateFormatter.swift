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

    func timeDifference(from startTime: String, to endTime: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone.current

        guard let start = dateFormatter.date(from: startTime),
              var end = dateFormatter.date(from: endTime) else {
            return nil
        }

     
        if end < start {
            var dayComponent = DateComponents()
            dayComponent.day = 1
            end = Calendar.current.date(byAdding: dayComponent, to: end) ?? end
        }

        let difference = Calendar.current.dateComponents([.hour, .minute], from: start, to: end)

        if let hour = difference.hour, let minute = difference.minute {
            return String(format: "%02d:%02d", hour, minute)
        } else {
            return nil
        }
    }


}
