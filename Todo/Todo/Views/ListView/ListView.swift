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

   
    var body: some View {
        VStack(alignment:.leading){
            HStack(alignment: .top){
                VStack(alignment: .leading)
                {
                            Image(systemName: icon)
                                .padding(.bottom,1)
                                .foregroundColor(Color(hex: color))
                                .font(.title3)
                                .fontWeight(.bold)
                            
                        
                    
                        .frame(width: 40, height: 40,alignment: .leading)
                    Text(name)
                        .foregroundColor(Color(hex: "6e7b8b"))
                        .font(.body)
                        .fontWeight(.bold)
                }
                Spacer()
                Text("\(count)")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(Color(hex: "6e7b8b") )
                
            }
            
        }

        .padding()
        .padding(.vertical, 10)
        .frame(height:  90)
        .background(RoundedRectangle(cornerRadius: 20)
            .stroke(Color(hex: "#384358").opacity(0.5), lineWidth: 1)
            .fill(LinearGradient(colors: [Color(hex:   "#384358").opacity(0.5),Color(hex:"#384358").opacity(0.2)], startPoint: .topTrailing, endPoint: .bottomLeading))
            .shadow(radius: 10)
//            .backgroundStyle1(cornerRadius: 20, opacity: 0.1)
        )
    }
}





@available(iOS 17.0, *)
struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let list = CDList(name: "", color: "D83F31", image: "", context: PersistenceController.shared.container.viewContext)
        let remainders = CDRemainder(context: PersistenceController.shared.container.viewContext, title: "Hello", notes: "")
        remainders.list = list
        remainders.schedule_ = CDRemainderSchedule(repeatCycle: "", date: "", time: "", duration: 0.0, context: PersistenceController.shared.container.viewContext)
        
        
        
        return Group {
            ListView(icon: "calendar", name: "Todo", color:  "FEBF63", count:  6)
                .preferredColorScheme(.dark)
        }
    }
}

//
//var body: some View {
//    VStack{
//        HStack(alignment: .top){
//            VStack(alignment: .leading)
//            {
//                Image(systemName: icon)
//                    .padding(.bottom,1)
//                    .foregroundColor(Color(hex: color))
//                    .font(.title3)
//                    .fontWeight(.bold)
//
//                Text(name)
//                    .foregroundColor(Color(hex: color))
//                    .font(.body)
//                    .fontWeight(.bold)
//            }
//            Spacer()
//            Text("\(count)")
//                .font(.title)
//                .fontWeight(.heavy)
//                .foregroundColor(Color(hex: color) )
//
//        }.padding(.top,remainders.count == 0 ? 5 : 20)
////                if remainders.count > 0 {
////                    RoundedRectangle(cornerRadius: 10)
////                        .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.6))
////                        .overlay(
////                            VStack(alignment: .leading) {
////                                ForEach(remainders.prefix(3)) { remainder in
////                                    HStack {
////                                        Text("•")
////                                            .foregroundColor(Color(hex:color))
////                                            .font(.system(size: 12))
////                                            .fontWeight(.heavy)
////                                        Text("\(remainder.title)")
////                                             .foregroundColor(Color(hex:color))
////                                        Spacer()
////                                    }
////                                    .padding(.leading,10)
////                                    .font(.system(size: 10))
////                                    .fontWeight(.heavy)
////                                }
////
////                            }
////
////                                .padding([.bottom,.top],20)
////                        )
////
////                        .frame(height: 50)
////                        .padding(.bottom,15)
////                }
//
//    }
//    .padding()
//    .padding(.vertical, 10)
//    .frame(height: remainders.count == 0 ? 90 : 145)
//    .background(.ultraThinMaterial
//    )
//
//    .backgroundStyle(cornerRadius: 20, opacity: colorScheme == .dark ? 0 : 0, colors: color)
//    .customBackground(colorScheme: colorScheme, color: color)
//
//
//}
