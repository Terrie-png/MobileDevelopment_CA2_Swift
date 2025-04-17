import Foundation
import SwiftUI

enum ApplicationStatus: String, Codable, Hashable, CaseIterable, Identifiable {
    case applied = "Applied"
    case interviewed = "Interviewed"
    case offered = "Offer Received"
    case rejected = "Rejected"
    
    var id: String { rawValue }
    
    var label: String {
        rawValue
    }
    
    var statusColor: Color {
        switch self {
        case .applied: return .blue
        case .interviewed: return .orange
        case .offered: return .green
        case .rejected: return .red
        }
    }
}
