////
////  signUpModel.swift
////  Todo
////
////  Created by Lawal Abdulganiy on 16/09/2023.
////
//
//import Foundation
//import Combine
//
//class AuthViewModel: ObservableObject{
//    @Published var email: String = ""
//    @Published var password: String = ""
//    @Published var success:Bool = false
//    @Published var errorEmailMessage = ""
//    @Published var errorPassMessage = ""
//    @Published var isEnabled = false
//    @Published var errorMessage = ""
//    @Published var isError = false
//    
//    private var cancellables = Set<AnyCancellable>()
//    var authModel:AuthenticationManager
//    
//    init(AuthModel:AuthenticationManager){
//        self.authModel = AuthModel
//        
//        isEmailValid.map{
//            $0 ? "" : "Enter a valid email address"
//        }.assign(to: &$errorEmailMessage)
//        
//        isPasswordaValid.map{
//            $0 ? "": "The password is less than 6 characters"
//        }.assign(to: &$errorPassMessage)
//        
//        buttonClickable.assign(to: &$isEnabled)
//    }
//    
//    private lazy var isEmailValid: AnyPublisher<Bool,Never> = {
//        $email
//            .debounce(for: 1, scheduler: RunLoop.main)
//            .map{ email in
//                let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
//                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
//                return emailPredicate.evaluate(with: email)
//            }
//            .eraseToAnyPublisher()
//    }()
//    
//    private lazy var isPasswordaValid: AnyPublisher<Bool,Never> = {
//        $password
//            .debounce(for: 1, scheduler: RunLoop.main)
//            .map{pass in
//                return pass.count > 6
//        }
//        .eraseToAnyPublisher()
//    }()
//    
//
//    private lazy var buttonClickable: AnyPublisher<Bool, Never> = {
//        Publishers.CombineLatest(isEmailValid, isPasswordaValid)
//            .map { (isValidEmail, isValidPassword) in
//                return isValidEmail && isValidPassword
//            }
//            .eraseToAnyPublisher()
//    }()
//
//    
//    func createUser(){
//        authModel.createUser(email: email, pass: password)
//            .sink { [unowned self] result in
//                switch result{
//                case .failure(let error):
//                    self.isError = true
//                    self.setErrorMessage(for: error)
//                    print("\(error)")
//                case .finished:
//                    print("Finished")
//                }
//            } receiveValue: { [weak self] _ in
//                self!.success = true
//            }.store(in: &cancellables)
//    }
//    
//    func signIn(){
//        authModel.signIn(email: email, pass: password)
//            .sink { [unowned self] result in
//                switch result{
//                case .failure(let error):
//                    self.isError = true
//                    self.setErrorMessage(for: error)
//                    print("\(error)")
//                case .finished:
//                    print("Finished")
//                }
//            } receiveValue: { [weak self] _ in
//                self!.success = true
//            }.store(in: &cancellables)
//    }
//    
//    func signOut(){
//        do{
//            try authModel.signOut()
//        }catch(let error){
//            print(error.localizedDescription)
//        }
//    }
//    
//    private func setErrorMessage(for error: Error) {
//          if let authError = error as? AuthError {
//              switch authError {
//              case .invalidEmail:
//                  errorMessage = "Invalid email address."
//              case .weakPassword:
//                  errorMessage = "The password is too weak."
//         
//                                }
//          } else {
//              errorMessage = "An error occurred during authentication."
//
//          }
//      }
//    
//    enum AuthError: Error {
//        case invalidEmail
//        case weakPassword
//    }
//}
