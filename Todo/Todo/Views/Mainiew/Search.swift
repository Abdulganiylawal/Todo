//
//  Search.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 19/09/2023.
//

import SwiftUI
import CoreData

@available(iOS 17.0, *)
struct SearchView: View {
    
    @StateObject var searchModel: SearchViewModel
   
    init(context:NSManagedObjectContext) {
        _searchModel = StateObject(wrappedValue:  SearchViewModel(context: context))
    }
    
    var body: some View {

            VStack {
                SearchBar(searchText: $searchModel.searchText)
                    .padding(0)
                ScrollView(showsIndicators: false) {
                    ForEach(searchModel.results){ remainder in
                        RemainderRow(remainder: remainder, color: remainder.list?.color ?? "", duration: remainder.schedule_?.duration ?? 0.0)
                            .padding()
                    }
                }
                .listRowSeparator(.hidden)
                .listStyle(PlainListStyle())
            }


    }
    
    struct SearchBar: View {
        @Binding var searchText: String
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
                        isFocused = false
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

}


@available(iOS 17.0, *)
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(context: PersistenceController.shared.container.viewContext)
            .preferredColorScheme(.dark)
    }
}
