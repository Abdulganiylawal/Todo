//
//  Home.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 19/09/2023.
//

import SwiftUI

struct Home: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var model = ListViewManger()
    @State var isClicked: Bool = false
    var body: some View {
        NavigationStack{
            VStack() {
                List{
                    Section{
                        All
                        HStack{
                            Today
                            Spacer()
                            Schedule
                        }.listRowSeparator(.hidden)
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10,  trailing: 0))
                    Section{
                        ForEach($model.myList,id:\.self.id) { $list in
                            NavigationLink {
                                RemainderView(viewModel: $list)
                            } label: {
                                HStack{
                                    Image(systemName: list.image)
                                        .foregroundColor(Color(hex: list.color))
                                    Text(list.name)
                                    Spacer()
                                    Text("\(list.remainders.count)")
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 15))
                            
                        }
                        
                    }header: {
                        HStack{
                            Text("MY LISTS")
                                .fontWeight(.bold)
                            Spacer()
                            Button {
                                isClicked.toggle()
                            } label: {
                                Image(systemName: "plus.app.fill")
                                
                            }
                        }
                    }   .sheet(isPresented: $isClicked) {
                        NavigationStack{
                            AddList(manager: model)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
        
                .navigationTitle("Tasks")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: colorScheme == .dark ? "000000" : "C4C1A4"))
        }

    }
    
    var All:some View{
        HStack {
            VStack {
                Image(systemName: "tray")
                    .resizable()
                    .frame(width: 28, height: 25)
                    .foregroundColor(Color(hex: colorScheme == .dark ? "27E1C1": "618264"))
                    .fontWeight(.bold)
                Text("All")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: colorScheme == .dark ? "27E1C1": "618264"))
            }
            Spacer()
            Text("1")
                .font(.title2)
                .fontWeight(.heavy)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .padding(10)
        .background(Color(hex: colorScheme == .dark ? "272829":"FAF2D3"))
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(colorScheme == .light ? 0.5 : 0), radius: 5, x: 0, y: 2)
        
    }
    
    var Today:some View{
        HStack{
            VStack(alignment:.leading){
                Image(systemName: "sun.max")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color(hex: colorScheme == .dark ?  "F8DE22": "FFD966"))
                Text("Today")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: colorScheme == .dark ?  "F8DE22":"FFD966"))
            }
            Spacer()
            Text("1")
                .font(.title2)
                .fontWeight(.heavy)
        }
        .padding(10)
        .background(Color(hex: colorScheme == .dark ? "272829": "EFB495"))
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(colorScheme == .light ? 0.5 : 0), radius: 5, x: 0, y: 2)
        
    }
    
    var Schedule:some View{
        HStack{
            VStack(alignment:.leading){
                Image(systemName: "calendar.badge.clock")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color(hex: colorScheme == .dark ? "D80032": "C63D2F"))
                Text("Scheduled")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: colorScheme == .dark ? "D80032": "C63D2F"))
            }
            Spacer()
            Text("1")
                .font(.title2)
                .fontWeight(.heavy)
        }

        .padding(10)
        .background(Color(hex: colorScheme == .dark ? "272829" : "8ECDDD"))
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(colorScheme == .light ? 0.5 : 0), radius: 5, x: 0, y: 2)
  
    }
    
}

#Preview
{
   return Home()
    
}
