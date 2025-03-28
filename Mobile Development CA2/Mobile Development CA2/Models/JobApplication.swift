//
//  JobApplication.swift
//  Mobile Development CA2
//
//  Created by Student on 28/03/2025.
//

import Foundation

struct JobApplication: Identifiable, Hashable {
    let id = UUID()
    let profileImage: String
    let name: String
    let rating: String
    let location: String
    let experience: String
    let jobType: String
    let jobTitle: String
    let seniority: String
    let salary: String
    let status: ApplicationStatus
    let applicationDate: Date
}
