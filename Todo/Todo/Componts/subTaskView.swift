//
//  subTaskView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 15/02/2024.
//

import SwiftUI

@available(iOS 17.0, *)
struct subTaskView: View {
    @State var subTasks:[CDRemainderSubTasks] = [CDRemainderSubTasks]()
    var remainder:CDRemainder
    
    var body: some View {
        NavigationStack{
            ScrollView{
                ForEach($subTasks) { $subTask in
                    SubTaskItem(name: $subTask.subTaskName, isCompleted: $subTask.isCompleted, isEditing: false, color: remainder.list!.color)
                        .padding(.bottom,5)
                }
            }
            .navigationTitle("SubTasks")
                .navigationBarTitleDisplayMode(.inline)
            .padding()
            .onAppear(perform: {
                subTasks = Array(remainder.subTasks)
            })
        }
      
    }
}

