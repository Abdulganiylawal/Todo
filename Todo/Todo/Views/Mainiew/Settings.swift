//
//  Settings.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 19/09/2023.
//

import SwiftUI

struct Settings: View {
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

struct Settings_Previews: PreviewProvider {
    static let data = AuthenticationManager()
    static var previews: some View {
        Settings(vm: data)
    }
}
