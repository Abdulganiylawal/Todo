//
//  Home.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 19/09/2023.
//

import SwiftUI

struct Home: View {
    @Environment(\.colorScheme) var colorScheme
    @State var isClicked: Bool = false
    var body: some View {
        VStack() {
            All
            HStack{
                Today
                Spacer()
                Schedule
            }.padding(.bottom,20)
            HStack(){
                Text("My Lists")
                Spacer()
                Button {
                    isClicked.toggle()
                } label: {
                    Image(systemName: "plus.app.fill")
                        .foregroundColor(Color(hex: "331D2C"))
                }

            }.padding()
            .sheet(isPresented: $isClicked) {
                    NavigationStack{
                        AddList()
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: colorScheme == .dark ? "000000" : "C4C1A4"))
      
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
            .padding(10)
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
        .padding([.top, .leading, .trailing], 10)
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
        .frame(width: 140)
        .frame(height: 60)
        .padding(10)
        .background(Color(hex: colorScheme == .dark ? "272829": "EFB495"))
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(colorScheme == .light ? 0.5 : 0), radius: 5, x: 0, y: 2)
        .padding([.top, .leading, .trailing], 10)
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
        .frame(width: 140)
        .frame(height: 60)
        .padding(10)
        .background(Color(hex: colorScheme == .dark ? "272829" : "8ECDDD"))
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(colorScheme == .light ? 0.5 : 0), radius: 5, x: 0, y: 2)
        .padding([.top, .leading, .trailing], 10)
    }

}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
