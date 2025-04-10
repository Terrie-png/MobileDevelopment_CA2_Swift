//
//  CardsController.swift
//  Mobile Development CA2
//
//  Created by Student on 03/04/2025.
//

import Foundation


class EmployeesController{
    private var filter :String=""
    
    private var EmployeesIntrested:  [CardView.Model] = []
    init(){}
    
    func AddEmployee (employee : CardView.Model) {
        EmployeesIntrested.append(employee)
        print(EmployeesIntrested)
    }
    
    func RemoveEmployee(employeeID: CardView.Model.ID ){
        if let idx = EmployeesIntrested.firstIndex(where: {$0.id == employeeID}){
            EmployeesIntrested.remove(at: idx)
        }
    }
    
    func ResetEmployee(){
        EmployeesIntrested.removeAll()
    }
    
    func GetAllEmployees()-> [CardView.Model]{
        return EmployeesIntrested
    }
    
    
}
