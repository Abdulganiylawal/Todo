//
//  ChatAssistant.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 19/03/2024.
//

import SwiftUI

@available(iOS 17.0, *)
struct ChatAssistant: View {
    @StateObject var viewModel = ChatAssistantViewModel()
    var body: some View {
        VStack{
            DropDownPickerView(list: viewModel.list)
            Spacer()
          
            TextMessageView(viewModel: viewModel)
                .padding(.bottom,10)
        }
    }
}


@available(iOS 17.0, *)
struct ChatAssistant_Previews: PreviewProvider {
    static var previews: some View{
        ChatAssistant()
    }

}

