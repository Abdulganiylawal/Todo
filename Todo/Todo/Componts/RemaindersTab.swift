//
//  RemaindersTab.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 11/02/2024.
//

import SwiftUI
import CoreData

@available(iOS 17.0, *)
struct RemaindersTab: View {
    @Binding var selectedTab:TabModel
    @Binding var isClicked:Bool
    @ObservedObject var model:RemainderViewModel
    var colors = "#a28089"
    var body: some View {
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .stroke(Color.gray, lineWidth: 0.5)
            .background(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(.thinMaterial)
            )
            .frame(width: 150,height: 45)
            .overlay {
                HStack{
                    Button(action:{selectedTab = .today
                        model.todayRemainders()}
                    , label: {
                        Image(systemName: selectedTab != .today ? "sun.max" : "sun.max.circle.fill"  )
                            .resizable()
                            .frame(width: 20,height: 20)
                            .foregroundStyle(Color.white)
                    })
                    .sensoryFeedback(.success, trigger: selectedTab == .today)
                    .padding()
                    Spacer()
                   
                    Button(action:{selectedTab = .scheduled
                        model.scheduleRemainders()
                    }
                    , label: {
                        Image(systemName: selectedTab != .scheduled ? "calendar" : "calendar.circle.fill")
                            .resizable()
                            .frame(width: 20,height: 20)
                            .foregroundStyle(Color.white)
                    })
                    .sensoryFeedback(.success, trigger: selectedTab == .scheduled)
                    Spacer()
                    Button(action: {
                        selectedTab = .add
                        isClicked.toggle()
                    }, label: {
                        Image(systemName: selectedTab != .add ?  "square.and.pencil" : "square.and.pencil.circle.fill")
                            .resizable()
                            .frame(width: 20,height: 20)
                            .foregroundStyle(Color.white)
                    })
                    .sensoryFeedback(.success, trigger: selectedTab == .add)
                    .padding()
                }
            }
        
    }
}

//#Preview {
//    if #available(iOS 17.0, *) {
//        RemaindersTab( isClicked: .constant(false))
//    } else {
//        EmptyView()
//    }
//}
