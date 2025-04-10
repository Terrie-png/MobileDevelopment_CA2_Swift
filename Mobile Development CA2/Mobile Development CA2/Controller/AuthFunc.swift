//
//  AuthFunc.swift
//  Mobile Development CA2
//
//  Created by Student on 28/03/2025.
//

import Foundation
import Security



class AuthController {
    private let service =  "com.SD.auth"
    static let shared = AuthController();
    private init() {}

    func login(username: String, password: String)-> Bool{
        if let retrievedData = KeychainHelper.shared.read(service: service, account: username){
            let retrievedPassword = String(data: retrievedData, encoding: .utf8)
            if retrievedPassword == password{
                return true
            }
            
        }
        return false
        
    }
    
    func register(username: String, password:String)-> Bool{
        
        if KeychainHelper.shared.read(service: service, account: username) != nil{
            return false;
        } else{
            if let passwordString = password.data(using: .utf8){
                KeychainHelper.shared.save(passwordString, service: service, account: username)
                return true
            }
            return false
        }
    }
    
}
