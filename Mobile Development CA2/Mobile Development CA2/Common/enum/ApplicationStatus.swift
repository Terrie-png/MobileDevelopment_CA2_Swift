//
//  ApplicationStatus.swift
//  Mobile Development CA2
//
//  Created by Student on 28/03/2025.
//

import Foundation
import SwiftUI

enum ApplicationStatus: String, Hashable {
    case applied = "Applied"
    case interviewed = "Interviewed"
    case offered = "Offer Received"
    case rejected = "Rejected"
    
    var statusColor: Color {
        switch self {
        case .applied: return .blue
        case .interviewed: return .orange
        case .offered: return .green
        case .rejected: return .red
        }
    }
}
