//
//  AuthenticationManager.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 18/09/2023.
//

import Foundation
import CombineFirebase
import Firebase
import Combine


final class AuthenticationManager{
    let auth = Auth.auth()
    func createUser(email:String,pass:String) -> Future <UserAuthModel,Error> {
        return Future<UserAuthModel,Error>{ [weak self] promise in
            self!.auth.createUser(withEmail: email, password: pass){ authResult, error in
                if let error = error{
                    promise(.failure(error))
                }else if let authResult = authResult {
                    promise(.success(UserAuthModel(user:authResult.user)))
                }
            }
        }
    }
    
    func signIn(email:String,pass:String) -> Future<UserAuthModel,Error> {
        return Future<UserAuthModel,Error>{ [weak self]
            promise in
            self!.auth.signIn(withEmail: email, password: pass){
                AuthDataResult , error in
                if let error = error{
                    promise(.failure(error))
                }
                else if let AuthDataResult = AuthDataResult{
                    promise(.success(UserAuthModel(user: AuthDataResult.user)))
                }
            }
        }
    }
    
    func signOut() throws {
           do {
               try Auth.auth().signOut()
           } catch {
               throw error
           }
       }
    }

