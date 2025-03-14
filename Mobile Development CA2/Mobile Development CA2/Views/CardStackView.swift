//
//  CardStackView.swift
//  Mobile Development CA2
//
//  Created by Student on 14/03/2025.
//

import SwiftUI

struct CardStackView: View {
    var employeeList:[CardsForEmployee]
    var body: some View {
        ZStack{
            ForEach(employeeList.indices.reversed(), id: \.self) { index in
                employeeList[index]
                CardView(employee:employeeList[index])
                    
                }
            }
        }
    }


#Preview {
    CardStackView(employeeList:[CardsForEmployee(
        id :UUID(),profileImage: "", // Replace with actual asset name
                               name: "Chelsea Knight",
                               rating: "4.8",
                               location: "New York",
                               experience: "3+ year",
                               jobType: "Full-time",
                               jobTitle: "Hardware Engineer",
                               seniority: "Senior",
                               salary: "$2400 / month"),
                                CardsForEmployee(
                                    id :UUID(),profileImage: "", // Replace with actual asset name
                                                           name: "Chelsea Knight",
                                                           rating: "4.8",
                                                           location: "New York",
                                                           experience: "3+ year",
                                                           jobType: "Full-time",
                                                           jobTitle: "Hardware Engineer",
                                                           seniority: "Senior",
                                                           salary: "$2400 / month")
    ])
}
