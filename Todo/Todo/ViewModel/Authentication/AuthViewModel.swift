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
    private var cancellables = Set<AnyCancellable>()
    var authModel:AuthenticationManager
    init(AuthModel:AuthenticationManager){
        self.authModel = AuthModel
    }
   
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
