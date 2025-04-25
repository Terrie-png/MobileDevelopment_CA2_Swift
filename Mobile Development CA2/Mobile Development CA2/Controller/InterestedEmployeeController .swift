//
//  InterestedEmployeeController .swift
//  Mobile Development CA2
//
//  Created by Student on 17/04/2025.
//

import Foundation
import SwiftData

class InterestedEmployeeController{
    static let shared = InterestedEmployeeController()
    
    private init(){}
    
    func getAllInterestedEmployees(context: ModelContext, ownerId: UUID) -> [InterestedEmployee]? {
        let fetchDescriptor = FetchDescriptor<InterestedEmployee>(predicate: #Predicate { $0.ownerId == ownerId })
        
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Error fetching employees: \(error.localizedDescription)")
            return nil
        }
    }

    // Fetch a single employee by ID
    func getInterestedEmployeeById(employeeId: UUID, ownerId: UUID, context: ModelContext) -> InterestedEmployee? {
        let fetchDescriptor = FetchDescriptor<InterestedEmployee>(predicate: #Predicate { $0.id == employeeId && $0.ownerId == ownerId })
        
        do {
            return try context.fetch(fetchDescriptor).first
        } catch {
            print("Error fetching employee by ID: \(error.localizedDescription)")
            return nil
        }
    }
    

    func deleteInterestedEmployee(employeeId: UUID, ownerId: UUID, context: ModelContext) -> Bool? {
        let fetchDescriptor = FetchDescriptor<InterestedEmployee>(predicate: #Predicate { $0.id == employeeId && $0.ownerId == ownerId })
        
        do {
            if let employee = try context.fetch(fetchDescriptor).first {
                context.delete(employee)
                try context.save()
                return true
            } else {
                print("Failed to delete interest employees , no employee is found")
                return false
            }
        } catch {
            print( "Error deleting employee: \(error.localizedDescription)")
            return false
        }
    }
}
