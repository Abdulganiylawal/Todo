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
                    .font(.title3)
                    .fontWeight(.heavy)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
            }
                if remainders.count > 0 {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(1))
                        .overlay(
                            VStack(alignment: .leading) {
                                ForEach(remainders.prefix(3)) { remainder in
                                    HStack {
                                        Text("•")
                                            .foregroundColor(Color(hex: color))
                                            .font(.system(size: 10))
                                        Text("\(remainder.title)")
                                            .foregroundColor(.secondary)
                                        Spacer()
                                    }
                                    .padding(.leading,10)
                                    .font(.system(size: 10))
                                    .fontWeight(.heavy)
                                }
                            }
                        )
                        .frame(height: 45)
                }
            
        }
        .padding()
        .padding(.vertical, 10)
        .frame(height: remainders.count == 0 ? 100 : 130)
        .background(.ultraThinMaterial)
        .backgroundStyle(cornerRadius: 20)
        .customBackground(condition: colorScheme == .light, color: color)
    }
}





@available(iOS 17.0, *)
struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let list = CDList(name: "", color: "D83F31", image: "", context: PersistenceController.shared.container.viewContext)
        let remainders = CDRemainder(context: PersistenceController.shared.container.viewContext, title: "Hello", notes: "")
        remainders.list = list
        remainders.schedule_ = CDRemainderSchedule(repeatCycle: "", date: "", time: "", context: PersistenceController.shared.container.viewContext)
        
        
        
        return Group {
            ListView(icon: "calendar", name: "Todo", color:  "FEBF63", count:  6, remainders: [])
        }
    }
}
