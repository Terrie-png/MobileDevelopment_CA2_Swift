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

    var body: some Scene {
        WindowGroup {
            SplashView().modelContainer(for: [Employee.self,InterestedEmployee.self, UserModel.self,ChatMesage.self])
                
        }
    }
}
