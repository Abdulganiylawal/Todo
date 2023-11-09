//
//  Search.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 19/09/2023.
//

import SwiftUI
import CoreData
@available(iOS 17.0, *)

struct Search: View {
    @StateObject var searchModel: SearchViewModel
    @Environment(\.colorScheme) var colorScheme
    @State var isActive:Bool = false
    
    var remaindersByList: [String: [CDRemainder]] {
        Dictionary(grouping: searchModel.results) { remainder in
            remainder.list!.name
        }
    }
    init(context:NSManagedObjectContext){
        _searchModel = StateObject(wrappedValue: SearchViewModel(context: context))
    }
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(searchText: $searchModel.searchText, isActive: $isActive)
                    .padding(.top,35)
                List {
                    ForEach(remaindersByList.keys.sorted(), id: \.self) { listName in
                        if let listColor = remaindersByList[listName]?.first?.list?.color {
                            Section(header: SectionHeader(title: listName, color: listColor)) {
                                ForEach(remaindersByList[listName] ?? [], id: \.self) { remainder in
                                    ListRow(remainder: remainder)
                                }
                            }
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .listStyle(PlainListStyle())
            }
        }.frame(maxWidth:.infinity,maxHeight:.infinity)
        
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var isActive:Bool
    @FocusState var isFocused:Bool
    
    var body: some View {
        HStack{
            HStack{
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("looking for something", text: $searchText)
                    .foregroundColor(.primary)
                    .focused($isFocused)
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(10)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            Button(action: {
                searchText = ""
              
                    isFocused.toggle()
                
            }, label: {
                Text("Cancel")
                    .foregroundColor(.secondary)
            })
        }
  
        .padding(.horizontal)
        .onDisappear{
            searchText = ""
        }
    }
}


@available(iOS 17.0, *)
struct SectionHeader: View {
    let title: String
    let color: String
    
    var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Color(hex: color))
    }
}

@available(iOS 17.0, *)
struct ListRow: View {
    let remainder: CDRemainder
    
    var body: some View {
        HStack(alignment: .top) {
            if remainder.isCompleted_ {
                  FilledCircle(color: remainder.list!.color)
                    .frame(width: 20, height: 20)
            } else {
               EmptyCircle(color: remainder.list!.color)
                    .frame(width: 20, height: 20)
            }
            VStack(alignment: .leading) {
                Text(remainder.title)
                    .foregroundColor(remainder.isCompleted_ ? .secondary : .primary)
                Text(remainder.notes)
                    .foregroundColor(remainder.isCompleted_ ? .secondary : .primary)
                if let originalDate = remainder.schedule_?.date,
                   let time = remainder.schedule_?.time,
                   let repeatCycle = remainder.schedule_?.repeatCycle {
                    DateTimeView(originalDate: originalDate, time: time, repeatCycle: repeatCycle)
                }
            }
        }
    }
}

@available(iOS 17.0, *)
extension ListRow {
    func FilledCircle(color:String) ->some View{
        Circle()
            .stroke(Color(hex: color), lineWidth: 2)
            .overlay(alignment: .center) {
                GeometryReader { geo in
                    VStack {
                        Circle()
                            .fill(Color(hex: color))
                            .frame(width: geo.size.width*0.7, height: geo.size.height*0.7, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
    }
    func EmptyCircle(color:String) -> some View{
        return Circle()
            .stroke(Color(hex: color))
    }
    
}


@available(iOS 17.0, *)
struct DateTimeView: View {
    let originalDate: String
    let time: String
    let repeatCycle: String
    
    var body: some View {
        HStack {
            Text(originalDate)
                .foregroundColor(.secondary)
            if !time.isEmpty {
                Text(",\(time)")
                    .foregroundColor(.secondary)
            }
            if !repeatCycle.isEmpty {
                Text(",\(Image(systemName: "repeat"))\(repeatCycle)")
                    .foregroundColor(.secondary)
            }
        }
    }
}

@available(iOS 17.0, *)
struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search(context: PersistenceController.shared.container.viewContext)
            .preferredColorScheme(.dark)
    }
}
