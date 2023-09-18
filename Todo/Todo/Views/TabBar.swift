//
//  TabBar.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 18/09/2023.
//

import SwiftUI

struct TabBar: View {
    @StateObject private var ViewModel:AuthViewModel
    @State var showAuthView = false
    
    init(vm:AuthenticationManager){
        _ViewModel = StateObject(wrappedValue: AuthViewModel(AuthModel: vm))
    }
    var body: some View {
        Button {
            ViewModel.signOut()
            showAuthView.toggle()
        } label: {
            Text("Log out")
        }.fullScreenCover(isPresented:$showAuthView) {
            NavigationStack{
                Authiew()
            }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static let data = AuthenticationManager()
    static var previews: some View {
        TabBar(vm: data)
    }
}
