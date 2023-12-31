////
////  SignUp.swift
////  Todo
////
////  Created by Lawal Abdulganiy on 18/09/2023.
////
//
//import SwiftUI
//
//@available(iOS 17.0, *)
//struct SignUp: View {
//    @StateObject private var ViewModel:AuthViewModel
//    @Environment(\.managedObjectContext) var context
//    @State private var isSecure: Bool = true
//    var model = AuthenticationManager()
//    init(vm:AuthenticationManager){
//        _ViewModel = StateObject(wrappedValue: AuthViewModel(AuthModel: vm))
//    }
//    
//    var body: some View {
//        NavigationStack{
//            Form {
//                Section(header: Text("Email"), footer: Text(ViewModel.errorEmailMessage).foregroundColor(.red)) {
//                    TextField("Enter your email", text: $ViewModel.email)
//                        .textInputAutocapitalization(.never)
//                }
//                Section(header: Text("Password"), footer: Text(ViewModel.errorPassMessage).foregroundColor(.red)) {
//                    PasswordField(placeholder: "Password", text: $ViewModel.password, isSecure: $isSecure)
//                        .textInputAutocapitalization(.never)
//                        .padding(6)
//                }
//                
//                Section {
//                    Button(action: {
//                        ViewModel.createUser()
//                    }) {
//                        Text("Sign Up")
//                    }.disabled(!ViewModel.isEnabled)
//                }.frame(maxWidth: .infinity, alignment: .center)
//                    .fullScreenCover(isPresented: $ViewModel.success) {
//                        NavigationStack{
//                            Home(context: context, authenticationManager: AuthenticationManager())
//                        }
//                    }.alert("Authentication Error", isPresented: $ViewModel.isError, actions: {
//                    //
//                    }) {
//                        Text("\(ViewModel.errorMessage)")
//                    }
//            }.navigationTitle("Sign up")
//        }
//    }
//    
//}
//@available(iOS 17.0, *)
//struct SignUp_Previews: PreviewProvider {
//    static let data = AuthenticationManager()
//    static var previews: some View {
//        SignUp(vm: data)
//    }
//}
