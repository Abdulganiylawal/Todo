//
//  Constants.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 19/03/2024.
//

import Foundation
import Firebase
import FirebaseFunctions

class GetApiKey{
    static let shared = GetApiKey()
    func getApiKey(){
        let functions = Functions.functions()
        let getApiKey = functions.httpsCallable("getApiKey")
        getApiKey.call { (result, error) in
            if let error = error {
                print("Error calling getApiKey function: \(error.localizedDescription)")
                return
            }
            
            if let data = result?.data as? [String: Any], let apiKey = data["apiKey"] as? String {
                print("API Key: \(apiKey)")
            } else {
                print("Invalid response from getApiKey function")
            }
        }

    }
}
