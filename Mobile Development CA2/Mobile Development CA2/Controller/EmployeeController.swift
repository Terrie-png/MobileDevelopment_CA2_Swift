import SwiftData
import SwiftUI

class EmployeeController {
    static let shared = EmployeeController()
    
    private init() {}
    
    // Fetch all employees
    func getAllEmployees(context: ModelContext) -> [Employee]? {
        let fetchDescriptor = FetchDescriptor<Employee>()
        
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Error fetching employees: \(error.localizedDescription)")
            return nil
        }
    }

    // Fetch a single employee by ID
    func getEmployeeById(employeeId: UUID, context: ModelContext) -> Employee? {
        let fetchDescriptor = FetchDescriptor<Employee>(predicate: #Predicate { $0.id == employeeId })
        
        do {
            return try context.fetch(fetchDescriptor).first
        } catch {
            print("Error fetching employee by ID: \(error.localizedDescription)")
            return nil
        }
    }

    // Update an employee's details
    func updateEmployee(employeeId: UUID, newJobTitle: String, newSalary: String, context: ModelContext) -> String? {
        let fetchDescriptor = FetchDescriptor<Employee>(predicate: #Predicate { $0.id == employeeId })
        
        do {
            if let employee = try context.fetch(fetchDescriptor).first {
                employee.jobTitle = newJobTitle
                employee.salary = newSalary
                
                try context.save()
                return nil
            } else {
                return "Employee not found!"
            }
        } catch {
            return "Error updating employee: \(error.localizedDescription)"
        }
    }

    // Delete an employee
    func deleteEmployee(employeeId: UUID, context: ModelContext) -> String? {
        let fetchDescriptor = FetchDescriptor<Employee>(predicate: #Predicate { $0.id == employeeId })
        
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
    
    func insertSampleEmployees( context: ModelContext) {
           // Make sure EmployeeSamples is an array of *data structs* or template objects,
           // not already-inserted SwiftData entities.
           for sample in EmployeeSamples {
               let employee = Employee(
                   profileImage: sample.profileImage,
                   name:         sample.name,
                   rating:       sample.rating,
                   location:     sample.location,
                   experience:   sample.experience,
                   jobType:      sample.jobType,
                   jobTitle:     sample.jobTitle,
                   seniority:    sample.seniority,
                   salary:       sample.salary,
                   geoLatitude: sample.geoLatitude,
                   geoLongitude: sample.geoLongitude
               )
               context.insert(employee)
           }

           do {
               try context.save()
           } catch {
               print("Error inserting sample employees:", error.localizedDescription)
           }
       }
    // Helper extension to extract numeric value from salary string
    
    
    func getUniqueEmployeeProperties(from employees: [Employee]) -> [String: Set<String>] {
        func uniqueValues(for keyPath: KeyPath<Employee, String>) -> Set<String> {
            return Set(employees.map { $0[keyPath: keyPath] })
        }
        
        let uniqueSalaries = Set(employees.map { $0.salary })
        
        return [
            "jobTypes": uniqueValues(for: \.jobType),
            "jobTitles": uniqueValues(for: \.jobTitle),
            "seniorities": uniqueValues(for: \.seniority),
            "locations": uniqueValues(for: \.location),
            "salaries": uniqueSalaries
        ]
    }
    
    
}
