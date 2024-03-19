//
//  repeatCycleManager.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 02/11/2023.
//

import Foundation
import CoreData

enum RepeatCycle: String, CaseIterable {
    case never = "Never"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
}

struct RepeatCycleManager {
    func nextDueDate(remainder:CDRemainder, context:NSManagedObjectContext){
        guard let repeatCycle = remainder.schedule_?.repeatCycle,
              let date = remainder.schedule_?.date,
              let originalTime = remainder.schedule_?.time else {
            return
        }
        let copiedRemainder = CDRemainder(context: context, title: remainder.title, notes: remainder.notes)
        copiedRemainder.list = remainder.list
        copiedRemainder.schedule_ = CDRemainderSchedule(repeatCycle: repeatCycle, date: date, time: originalTime, duration: 0.0, endTime: "", context: context)
        copiedRemainder.isCompleted_ = false
        let originalDate = dateFromString(date)
        
        switch RepeatCycle(rawValue: repeatCycle){
            case .daily:
                let newDate =  Calendar.current.date(byAdding: .day, value: 1, to: originalDate!)
                copiedRemainder.schedule_?.date = formattedDatesString(from: newDate!)
                return
            case .weekly:
                let newDate =  Calendar.current.date(byAdding: .weekOfYear, value: 1, to: originalDate!)
                copiedRemainder.schedule_?.date = formattedDatesString(from: newDate!)
                return
            case.monthly:
                let newDate =  Calendar.current.date(byAdding: .month, value: 1, to: originalDate!)
                copiedRemainder.schedule_?.date = formattedDatesString(from: newDate!)
                return
            case .yearly:
                let newDate =  Calendar.current.date(byAdding: .year, value: 1, to: originalDate!)
                copiedRemainder.schedule_?.date = formattedDatesString(from: newDate!)
                return
            default:
                return
        }
    }
    
    private func dateFromString(_ dateString: String) -> Date? {
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        return dateFormatter.date(from: dateString)
    }
    
    private func formattedDatesString(from component: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateComponents = component
        let formattedDates = dateFormatter.string(from: dateComponents)
        return formattedDates
    }
}
