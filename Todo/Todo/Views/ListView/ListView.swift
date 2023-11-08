//
//  ListView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 07/11/2023.
//

import SwiftUI

@available(iOS 17.0, *)
struct ListView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var icon:String
    @State var name:String
    @State var color:String
    @State var count:Int
    @State var remainders:[CDRemainder]
    var body: some View {
        VStack{
            HStack(alignment: .top){
                VStack(alignment: .leading)
                {
                    Image(systemName: icon)
                        .padding(.bottom,1)
                        .foregroundColor(Color(hex: color))
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text(name)
                        .foregroundColor(Color(hex: color))
                        .font(.body)
                        .fontWeight(.bold)
                }
                Spacer()
                Text("\(count)")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
            }.padding(.top,remainders.count == 0 ? 5 : 20)
                if remainders.count > 0 {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(1))
                        .overlay(
                            VStack(alignment: .leading) {
                                ForEach(remainders.prefix(3)) { remainder in
                                    HStack {
                                        Text("•")
                                            .foregroundColor(Color(hex:   remainder.list!.color))
                                            .font(.system(size: 12))
                                            .fontWeight(.heavy)
                                        Text("\(remainder.title)")
                                             .foregroundColor(Color(hex:   remainder.list!.color))
                                        Spacer()
                                    }
                                    .padding(.leading,10)
                                 
                                    .font(.system(size: 10))
                                    .fontWeight(.heavy)
                                }
                                
                            }
                                
                                .padding([.bottom,.top],20)
                        )
                     
                        .frame(height: 50)
                        .padding(.bottom,15)
                }
            
        }
        .padding()
        .padding(.vertical, 10)
        .frame(height: remainders.count == 0 ? 90 : 145)
        .background(.ultraThinMaterial)
        .backgroundStyle(cornerRadius: 20, opacity: colorScheme == .dark ? 0 : 0.6, colors: color)
        .customBackground(condition: colorScheme == .dark, color: color)
    }
}





@available(iOS 17.0, *)
struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let list = CDList(name: "", color: "D83F31", image: "", context: PersistenceController.shared.container.viewContext)
        let remainders = CDRemainder(context: PersistenceController.shared.container.viewContext, title: "Hello", notes: "")
        remainders.list = list
        remainders.schedule_ = CDRemainderSchedule(repeatCycle: "", date: "", time: "", duration: "", context: PersistenceController.shared.container.viewContext)
        
        
        
        return Group {
            ListView(icon: "calendar", name: "Todo", color:  "FEBF63", count:  6, remainders: [])
        }
    }
}
