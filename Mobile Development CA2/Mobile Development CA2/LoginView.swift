//
//  LoginView.swift
//  Mobile Development CA2
//
//  Created by Student on 13/03/2025.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    var body: some View {
        VStack{
            
            HStack {
                Text("Enter Username:").font(.headline)
                TextField("Username", text:$username).padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            HStack{
                Text("Enter Password:").font(.headline)
                TextField("Password", text:$password).padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            Button(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/) {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
            }
        }
    }
}

#Preview {
    LoginView()
}
