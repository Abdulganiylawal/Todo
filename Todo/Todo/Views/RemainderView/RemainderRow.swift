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
    @State private var isClicked = false
    var remainder:CDRemainder
    var duration:Double
    var select:String = ""
    
    init(color: String, remainder: CDRemainder, duration: Double, select: String) {
          self.color = color
          self.remainder = remainder
          self.duration = duration
          self.select = select
      }
    

    var progressInterval: ClosedRange<Date>? {
        guard let startTimeString = remainder.schedule_?.time,
              let startDateString = remainder.schedule_?.date,
              let start = dateTimeFromString(dateString: startDateString, timeString: startTimeString) else {
            return nil
        }
        let end = start.addingTimeInterval(TimeInterval(self.duration))
        
        return start...end
    }



    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            HStack{
                if !remainder.title.isEmpty {
                    Text(remainder.title)
                        .foregroundStyle(!remainder.isCompleted_ ? Color.white : .secondary)
                }
                Spacer()
                if  remainder.isCompleted_{
                            Text("Completed")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(8)
                    
                }
                if !remainder.subTasks.isEmpty{
                    Button {
                            isClicked.toggle()
                    } label: {
                        HStack{
                            Text("\(remainder.subTasks.count)")
                                .foregroundStyle(.gray)
                        }
                    }
                }
                
                if !select.isEmpty{
                    Text(remainder.list?.name ?? "" )
                        .font(.caption)
                        .foregroundStyle(Color(hex: remainder.list?.color ?? ""))
                        .padding(8)
                }
            }.padding(0)
              if !remainder.notes.isEmpty {
                  Text(remainder.notes)
                      .foregroundStyle(.secondary)
                      .frame(maxWidth: .infinity, alignment: .leading)
                      .foregroundColor(.primary.opacity(0.7))
              }
            
            if let interval = progressInterval, duration != 0.0 {
                ProgressView(timerInterval: interval,countsDown: false)
                    .tint(Color(hex: color))
                
            }
            
        
            Divider()
                .foregroundStyle(Color.white)
            HStack {
                if let date = remainder.schedule_?.date_, !date.isEmpty {
                    HStack {
                        Image(systemName: "calendar")
                            .font(.subheadline)
                        Text(date)
                            .font(.subheadline)
                    }
                    .foregroundStyle(.secondary)
                    Spacer()
                }
                
                

                if let time = remainder.schedule_?.time, !time.isEmpty {
                    HStack {
                        Image(systemName: "clock")
                            .font(.subheadline)
                        Text(time)
                            .font(.subheadline)
              
                    }
                    .foregroundStyle(.secondary)
                    .font(.body)
                    if let repeatCycle = remainder.schedule_?.repeatCycle, !repeatCycle.isEmpty{
                        Spacer()
                    }
                    
                }
                
                
                if let repeatCycle = remainder.schedule_?.repeatCycle, !repeatCycle.isEmpty {
                    HStack {
                        Image(systemName: "repeat")
                            .font(.subheadline)
                        Text(repeatCycle)
                            .font(.subheadline)
                    }
                    .font(.body)
                    .foregroundStyle(.secondary)
    
                }
            }
        }
       
        .transition(.move)
        .padding()
        .sheet(isPresented: $isClicked, content: {
            subTaskView(remainder: remainder)
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(16)
                .presentationDetents([.height(200)])
                .presentationBackground(.ultraThinMaterial)
        })
     
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(hex: color).opacity(0.3), lineWidth: 1)
                    .fill(LinearGradient(colors: [Color(hex: color).opacity(0.15),Color(hex: color).opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)))
    }
    
    func dateTimeFromString(dateString: String, timeString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        let combinedString = "\(dateString) \(timeString)"
        return dateFormatter.date(from: combinedString)
    }
}


@available(iOS 17.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    
    static var previews: some View{
        let list = CDList(name: "Testing", color: "D83F31", image: "", context: PersistenceController.shared.container.viewContext)
        let remainders = CDRemainder(context: PersistenceController.shared.container.viewContext, title: "Hello", notes: "djdjdjlkjnankasnckcnkscnknc")
        remainders.list = list
        remainders.isCompleted_ = true
        remainders.schedule_ = CDRemainderSchedule(repeatCycle: "monthly", date: "26-08-02", time: "12:00", duration: 3600, context: PersistenceController.shared.container.viewContext)
        return Group {
            RemainderRow(color:  "#4A4C8", remainder: remainders, duration: 360.0, select: "")
        }
    }
}


