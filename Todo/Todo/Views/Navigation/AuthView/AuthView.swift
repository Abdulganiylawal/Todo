//
//  Authiew.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 18/09/2023.
//

import SwiftUI
import FirebaseAuth

struct Authiew: View {
    @Environment(\.colorScheme) var colorScheme
    var model = AuthenticationManager()
    var body: some View {
     VStack{
        NavigationStack{
            NavigationLink {
                SignUp(vm: model)
            } label: {
                Text("Sign Up")
                    .font(.system(size: 15,weight: .bold))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(width: 200)
                    .padding(10)
                    .background(Color.blue)
                    .clipShape(Capsule())
                
            }
            NavigationLink {
                SignIn(vm: model)
            } label: {
                Text("Log in")
                    .font(.system(size: 15,weight: .bold))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
        }
       }
    }
}

struct Authiew_Previews: PreviewProvider {

    static var previews: some View {
        
        Authiew()
    }
}
