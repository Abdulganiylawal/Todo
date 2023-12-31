////
////  SignIn.swift
////  Todo
////
////  Created by Lawal Abdulganiy on 18/09/2023.
////
//
//import SwiftUI
//
//@available(iOS 17.0, *)
//struct SignIn: View {
//    @StateObject private var ViewModel:AuthViewModel
//    @Environment(\.managedObjectContext) var context
//    init(vm:AuthenticationManager){
//        _ViewModel = StateObject(wrappedValue: AuthViewModel(AuthModel: vm))
//    }
//    @State private var isSecure: Bool = true
//    var body: some View {
//        NavigationStack{
//            Form {
//                Section(header: Text("Email"), footer: Text(ViewModel.errorEmailMessage).foregroundColor(.red)) {
//                    TextField("Enter your email", text: $ViewModel.email)
//                        .textInputAutocapitalization(.never)
//                }
//                Section(header: Text("Password"), footer: Text(ViewModel.errorPassMessage).foregroundColor(.red)) {
//                    PasswordField(placeholder: "Password", text: $ViewModel.password, isSecure: $isSecure)
//                        .padding(6)
//                        .textInputAutocapitalization(.never)
//                }
//                
//                Section {
//                    Button(action: {
//                        ViewModel.signIn()
//                    }) {
//                        Text("Log In")
//                    }.disabled(!ViewModel.isEnabled)
//                }.frame(maxWidth: .infinity, alignment: .center)
//            } .fullScreenCover(isPresented: $ViewModel.success) {
//                NavigationStack{
//                    Home(context: context, authenticationManager: AuthenticationManager())
//                }
//            }
//            .alert("Authentication Error", isPresented: $ViewModel.isError, actions: {
//                // You can add actions here if needed
//            }) {
//                Text("\(ViewModel.errorMessage)")
//            }
//        }
//        .navigationTitle("Log in")
//    }
//    
//}
//
//
//@available(iOS 17.0, *)
//struct SignIn_Previews: PreviewProvider {
//    static let data = AuthenticationManager()
//    static var previews: some View {
//        
//        SignIn(vm: data)
//    }
//}
