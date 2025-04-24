//
//  UserController.swift
//  Mobile Development CA2
//
//  Created by Student on 22/04/2025.
//

import Foundation
import SwiftData

class UserController{
    static let shared = UserController()
    
    private init(){}
    
    @MainActor
    func updateUserLocation(username: String, latitude: Double, longitude: Double, modelContext: ModelContext) {
        let descriptor = FetchDescriptor<UserModel>(predicate: #Predicate { $0.username == username })
        
        do {
            if let user = try modelContext.fetch(descriptor).first {
                user.geoLatitude = latitude
                user.geoLongitude = longitude
                
                try modelContext.save() 
                print("User location updated.")
            } else {
                print("User not found.")
            }
        } catch {
            print("Failed to update user: \(error)")
        }
    }
    
    @MainActor
    func getUserDetail(username: String ,modelContext: ModelContext)-> UserModel?{
        let descriptor = FetchDescriptor<UserModel>(predicate: #Predicate{$0.username == username})
        
        do {
            return try modelContext.fetch(descriptor).first
        } catch {
            print("Error fetching employee by ID: \(error.localizedDescription)")
            return nil
        }
    }
}
