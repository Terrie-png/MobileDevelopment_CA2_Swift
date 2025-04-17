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
    
    func getAllInterestedEmployees(context: ModelContext) -> [InterestedEmployee]? {
        let fetchDescriptor = FetchDescriptor<InterestedEmployee>()
        
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Error fetching employees: \(error.localizedDescription)")
            return nil
        }
    }

    // Fetch a single employee by ID
    func getInterestedEmployeeById(employeeId: UUID, context: ModelContext) -> InterestedEmployee? {
        let fetchDescriptor = FetchDescriptor<InterestedEmployee>(predicate: #Predicate { $0.id == employeeId })
        
        do {
            return try context.fetch(fetchDescriptor).first
        } catch {
            print("Error fetching employee by ID: \(error.localizedDescription)")
            return nil
        }
    }
    

    func deleteInterestedEmployee(employeeId: UUID, context: ModelContext) -> String? {
        let fetchDescriptor = FetchDescriptor<InterestedEmployee>(predicate: #Predicate { $0.id == employeeId })
        
        do {
            if let employee = try context.fetch(fetchDescriptor).first {
                context.delete(employee)
                try context.save()
                return nil
            } else {
                return "Employee not found!"
            }
        } catch {
            return "Error deleting employee: \(error.localizedDescription)"
        }
    }
}
