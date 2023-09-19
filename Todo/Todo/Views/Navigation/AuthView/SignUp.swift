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
    var model = AuthenticationManager()
    init(vm:AuthenticationManager){
      _ViewModel = StateObject(wrappedValue: AuthViewModel(AuthModel: vm))
    }
    
    var body: some View {
        NavigationStack{
            Form{
                Section {
                    TextField("Enter your email", text: $ViewModel.email)
                        .textInputAutocapitalization(.none)
                } header: {
                    Text("Email")
                } footer: {
                    Text(ViewModel.errorEmailMessage)
                        .foregroundColor(.red)
                }
                
                Section {
                    PasswordField(placeholder: "Password", text: $ViewModel.password, isSecure: $isSecure)
                        .padding(6)
                } header: {
                    Text("Password")
                } footer: {
                    Text(ViewModel.errorPassMessage)
                        .foregroundColor(.red)
                }
                
                Section{
                    Button {
                        ViewModel.createUser()
                    } label: {
                        Text("Sign up")
                    }.disabled(!ViewModel.isEnabled)
                }.frame(maxWidth: .infinity, alignment: .center)
                    .fullScreenCover(isPresented: $ViewModel.success) {
                        NavigationStack{
                            TabBar(vm: model)
                        }
                    }
            }  .alert("Authentication Error", isPresented: $ViewModel.isError, actions: {
                // You can add actions here if needed
            }) {
                Text("\(ViewModel.errorMessage)")
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
