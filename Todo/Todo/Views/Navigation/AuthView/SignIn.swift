//
//  SignIn.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 18/09/2023.
//

import SwiftUI

struct SignIn: View {
    @StateObject private var ViewModel:AuthViewModel
    @State var loggedIn = false
    var model = AuthenticationManager()
    
    init(vm:AuthenticationManager){
        _ViewModel = StateObject(wrappedValue: AuthViewModel(AuthModel: vm))
    }
    @State private var isSecure: Bool = true
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
                        ViewModel.signIn()
                        loggedIn.toggle()
                    } label: {
                        Text("Log in")
                    }
                }.frame(maxWidth: .infinity, alignment: .center)
                    .fullScreenCover(isPresented: $loggedIn) {
                        NavigationStack{
                            TabBar(vm: model)
                        }
                    }
            }
            
        }
        .navigationTitle("Log in")
    }
    
}


struct SignIn_Previews: PreviewProvider {
    static let data = AuthenticationManager()
    static var previews: some View {
        
        SignIn(vm: data)
    }
}
