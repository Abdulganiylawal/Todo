//
//  Calender.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 27/09/2023.
//

import SwiftUI

struct calender: View {
    @State private var dates = Date()
    @Environment(\.presentationMode) var presentationMode
    @Binding var date: String
    
    var body: some View {
        List {
            DatePicker(
                   "Start Date",
                   selection: $dates,
                   displayedComponents: [.date]
               )
               .datePickerStyle(.graphical)
        }
        .toolbar(content: {
            ToolbarItem {
                Button {
                    date = formattedDatesString(from: dates)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Done")
                }

            }
        })
    }
    
    private func formattedDatesString(from dateComponentsSet: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"

        let dateComponents = dateComponentsSet
        let formattedDates = dateFormatter.string(from: dateComponents)

        return formattedDates
    }
}

