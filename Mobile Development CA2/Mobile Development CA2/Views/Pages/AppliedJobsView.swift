import SwiftUI

// Modify JobApplication to match the new structure
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

// Keep the existing ApplicationStatus enum
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

// Applied Jobs View
struct AppliedJobsView: View {
    // Updated sample job applications to match the new structure
    let jobApplications: [JobApplication] = [
        JobApplication(
            profileImage: "", // Replace with actual asset name
            name: "Chelsea Knight",
            rating: "4.8",
            location: "New York",
            experience: "3+ year",
            jobType: "Full-time",
            jobTitle: "Hardware Engineer",
            seniority: "Senior",
            salary: "$2400 / month",
            status: .applied,
            applicationDate: Date().addingTimeInterval(-30 * 24 * 60 * 60)
        ),
        JobApplication(
            profileImage: "", // Replace with actual asset name
            name: "Chelsea Knight",
            rating: "4.8",
            location: "New York",
            experience: "3+ year",
            jobType: "Full-time",
            jobTitle: "Hardware Engineer",
            seniority: "Senior",
            salary: "$2400 / month",
            status: .interviewed,
            applicationDate: Date().addingTimeInterval(-15 * 24 * 60 * 60)
        ),
        JobApplication(
            profileImage: "", // Replace with actual asset name
            name: "Chelsea Knight",
            rating: "4.8",
            location: "New York",
            experience: "3+ year",
            jobType: "Full-time",
            jobTitle: "Hardware Engineer",
            seniority: "Senior",
            salary: "$2400 / month",
            status: .offered,
            applicationDate: Date().addingTimeInterval(-45 * 24 * 60 * 60)
        ),
        JobApplication(
            profileImage: "", // Replace with actual asset name
            name: "Chelsea Knight",
            rating: "4.8",
            location: "New York",
            experience: "3+ year",
            jobType: "Full-time",
            jobTitle: "Hardware Engineer",
            seniority: "Senior",
            salary: "$2400 / month",
            status: .applied,
            applicationDate: Date().addingTimeInterval(-10 * 24 * 60 * 60)
        ),
        JobApplication(
            profileImage: "", // Replace with actual asset name
            name: "Jason Njoku",
            rating: "5",
            location: "New York",
            experience: "3+ year",
            jobType: "Full-time",
            jobTitle: "Hardware Engineer",
            seniority: "Senior",
            salary: "$8400 / month",
            status: .rejected,
            applicationDate: Date().addingTimeInterval(-60 * 24 * 60 * 60)
        )
    ]
    @Binding var isVisible : Bool
    var body: some View {
        List(jobApplications) { application in
            NavigationLink(destination: JobApplicationDetailView(jobApplication: application, isVisible: $isVisible)) {
                HStack {
                    // Placeholder for profile image
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(application.name)
                            .font(.headline)
                        
                        Text(application.jobTitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Text(application.status.rawValue)
                                .font(.caption2)
                                .padding(4)
                                .background(application.status.statusColor)
                                .foregroundColor(.white)
                                .cornerRadius(4)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .listStyle(PlainListStyle())
    }
}

// Update JobApplicationDetailView to match new structure
struct JobApplicationDetailView: View {
    let jobApplication: JobApplication
    @Binding var isVisible:Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Back Button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color.white)
            
            // Scrollable Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Job Header
                    VStack(alignment: .leading, spacing: 10) {
                        Text(jobApplication.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(jobApplication.jobTitle)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        // Status Tag
                        Text(jobApplication.status.rawValue)
                            .font(.caption)
                            .padding(6)
                            .background(jobApplication.status.statusColor)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                    .padding(.bottom)
                    
                    // Job Details
                    Group {
                        DetailRow(
                            icon: "briefcase",
                            title: "Job Type",
                            value: jobApplication.jobType
                        )
                        
                        DetailRow(
                            icon: "star",
                            title: "Seniority",
                            value: jobApplication.seniority
                        )
                        
                        DetailRow(
                            icon: "location",
                            title: "Location",
                            value: jobApplication.location
                        )
                        
                        DetailRow(
                            icon: "clock",
                            title: "Experience",
                            value: jobApplication.experience
                        )
                        
                        DetailRow(
                            icon: "dollarsign.circle",
                            title: "Salary",
                            value: jobApplication.salary
                        )
                        
                        DetailRow(
                            icon: "calendar",
                            title: "Application Date",
                            value: formatDate(jobApplication.applicationDate)
                        )
                    }
                    
                    // Action Buttons
                    HStack(spacing: 15) {
                        Button(action: {
                            // Withdraw Application
                        }) {
                            Text("Withdraw")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.top)
                }
                .padding()
            }
        }.onAppear{
            isVisible = false
        }
        .navigationBarHidden(true)
    }
    
    // Date Formatter
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

// Reusable Detail Row (remains the same)
struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                Text(value)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

// Preview
#Preview {
     @Previewable @State var isVisible  = false
    AppliedJobsView(isVisible: $isVisible)
}
