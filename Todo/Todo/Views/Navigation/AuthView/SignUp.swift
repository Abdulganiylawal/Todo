//
//  SignUp.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 18/09/2023.
//

import SwiftUI

struct SignUp: View {
    @StateObject private var ViewModel:AuthViewModel
    @State private var isSecure: Bool = true
    @State var loggedIn = false
    var model = AuthenticationManager()
    init(vm:AuthenticationManager){
      _ViewModel = StateObject(wrappedValue: AuthViewModel(AuthModel: vm))
    }
    
    var body: some View {
        NavigationStack{
            Form{
                Section("Email") {
                    TextField("Enter your email", text: $ViewModel.email)
                }
                Section("password") {
                    PasswordField(placeholder: "Password", text: $ViewModel.password, isSecure: $isSecure)
                        .padding(6)
                }
                Section{
                    Button {
                        ViewModel.createUser()
                        loggedIn.toggle()
                    } label: {
                        Text("Sign up")
                    }
                }.frame(maxWidth: .infinity, alignment: .center)
                    .fullScreenCover(isPresented: $ViewModel.success) {
                        NavigationStack{
                            TabBar(vm: model)
                        }
                    }
            }
        }.navigationTitle("Sign up")
    }
}

struct SignUp_Previews: PreviewProvider {
    static let data = AuthenticationManager()
    static var previews: some View {
        SignUp(vm: data)
    }
}
