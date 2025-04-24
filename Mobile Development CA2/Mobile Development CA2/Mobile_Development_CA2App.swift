//
//  Mobile_Development_CA2App.swift
//  Mobile Development CA2
//
//  Created by Student on 13/03/2025.
//

import SwiftUI
import SwiftData


@main
struct Mobile_Development_CA2App: App {

    @State var isloggedIn:Bool = false
    var authController = AuthController.shared
    var body: some Scene {
        WindowGroup {
            if(isloggedIn){
                CompiledMainPageView().modelContainer(for: [Employee.self,InterestedEmployee.self, UserModel.self])
            } else{
                LoginView(isLoggedIn: $isloggedIn).modelContainer(for: UserModel.self)
            }
        }
    }
}
