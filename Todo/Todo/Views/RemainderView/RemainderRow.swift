////
////  SwiftUIView.swift
////  Todo
////
////  Created by Lawal Abdulganiy on 07/11/2023.
////
//
import SwiftUI

@available(iOS 17.0, *)
struct RemainderRow: View {
    @Environment(\.colorScheme) var colorScheme
    var color:String = ""
    var remainder:CDRemainder
    var dateFormatterModel = DateFormatterModel()
    let duration:Double
    
    var progressInterval: ClosedRange<Date>? {
        guard let startTimeString = remainder.schedule_?.time,
              let startDateString = remainder.schedule_?.date,
              let start = dateTimeFromString(dateString: startDateString, timeString: startTimeString) else {
            return nil
        }
        print(start)
        let end = start.addingTimeInterval(TimeInterval(self.duration))
        return start...end
    }


    init(remainder:CDRemainder, color:String, duration:Double){
        self.color = color
        self.remainder = remainder
        self.duration = duration
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text(remainder.title)
                .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
            Text(remainder.notes)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.primary.opacity(0.7))
               if let interval = progressInterval {
                   ProgressView(timerInterval: interval,countsDown: false)
                       .tint(Color(hex: color))
                
            }
            Divider()
                .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
            HStack{
                Text(remainder.schedule_?.date ?? "")
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                Text(remainder.schedule_?.time ?? "")
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                Text(remainder.schedule_?.repeatCycle ?? "")
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
            }
            
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .stroke(Color(hex: color)).opacity(colorScheme == .dark ? 0.4 : 0.7)
                .customBackgroundForRemainderRow( colorscheme: colorScheme, color: color)
        )
    }
    
    func dateTimeFromString(dateString: String, timeString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm a" // e.g., "26-08-02 6:23 AM"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Handles 12/24 hour time format

        let combinedString = "\(dateString) \(timeString)"
        return dateFormatter.date(from: combinedString)
    }
}


@available(iOS 17.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    
    static var previews: some View{
        let list = CDList(name: "", color: "D83F31", image: "", context: PersistenceController.shared.container.viewContext)
        let remainders = CDRemainder(context: PersistenceController.shared.container.viewContext, title: "Hello", notes: "lorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsum")
        remainders.list = list
        remainders.schedule_ = CDRemainderSchedule(repeatCycle: "monthly", date: "26-08-02", time: "12:00", duration: 3600, context: PersistenceController.shared.container.viewContext)
        return Group {
            RemainderRow(remainder: remainders, color: "D83F31", duration: 0.0)
        }
    }
}


 
