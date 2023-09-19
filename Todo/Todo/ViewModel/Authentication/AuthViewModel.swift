//
//  signUpModel.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 16/09/2023.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject{
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var success:Bool = false
    @Published var errorEmailMessage = ""
    @Published var errorPassMessage = ""
    private var cancellables = Set<AnyCancellable>()
    var authModel:AuthenticationManager
    
    init(AuthModel:AuthenticationManager){
        self.authModel = AuthModel
        
        isEmailValid.map{
            $0 ? "" : "Enter a valid email address"
        }.assign(to: &$errorEmailMessage)
        
        isPasswordaValid.map{
            $0 ? "": "The password is less than 6 characters"
        }.assign(to: &$errorPassMessage)
    }
    
    private lazy var isEmailValid: AnyPublisher<Bool,Never> = {
        $email
            .debounce(for: 1, scheduler: RunLoop.main)
            .map{ email in
                let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
                return emailPredicate.evaluate(with: email)
            }
            .eraseToAnyPublisher()
    }()
    
    private lazy var isPasswordaValid: AnyPublisher<Bool,Never> = {
        $password
            .debounce(for: 1, scheduler: RunLoop.main)
            .map{pass in
                return pass.count > 6
        }
        .eraseToAnyPublisher()
    }()
    
    
    
    func createUser(){
        authModel.createUser(email: email, pass: password)
            .sink { result in
                switch result{
                case .failure(let error):
                    print("\(error.localizedDescription)")
                case .finished:
                    
                    print("Finished")
                    
                }
            } receiveValue: { [weak self] value in
                self!.success = true
                print(self!.success)
                print(value)
            }.store(in: &cancellables)
    }
    
    func signIn(){
        authModel.signIn(email: email, pass: password)
            .sink {  result in
                switch result{
                case .failure(let error):
                    print("\(error.localizedDescription)")
                case .finished:
                    print("Finished")
                }
            } receiveValue: { [weak self] value in
                self!.success = true
                print(self!.success)
                print(value)
            }.store(in: &cancellables)
    }
    
    func signOut(){
        do{
            try authModel.signOut()
        }catch(let error){
            print(error)
        }
    }
}
