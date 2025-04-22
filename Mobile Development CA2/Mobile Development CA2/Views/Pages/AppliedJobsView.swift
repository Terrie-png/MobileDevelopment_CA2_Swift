import SwiftUI

// Applied Jobs View
struct AppliedJobsView: View {
    // Updated sample job applications to match the new structure
    @State var jobApplications: [JobApplication] = [
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
    
    @Environment(\.modelContext) var modelContext
    var controller = InterestedEmployeeController.shared // This makes sure it's initialized and persists
    var employeeController = EmployeeController.shared
    @State private var interestedEmployees: [InterestedEmployee] = []
    var body: some View {
        ZStack{
            Color.secondaryColor.ignoresSafeArea()
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
                }.listRowBackground(Color.clear)
            }
            
        }
        .listStyle(PlainListStyle())
        .background(Color.clear)
        .onAppear {
            let allEmployees = employeeController.getAllEmployees(context: modelContext) ?? []
            let interestedList = controller.getAllInterestedEmployees(context: modelContext) ?? []
            
            let employeeDict = Dictionary(uniqueKeysWithValues: allEmployees.map { ($0.id, $0) })
            
            var datajobApplications: [JobApplication] = interestedList.compactMap { interest in
                // Find matching employee by ID
                guard let employee = employeeDict[interest.id] else { return nil }
                
                return JobApplication(
                    profileImage: employee.profileImage,
                    name: employee.name,
                    rating: employee.rating,
                    location: employee.location,
                    experience: employee.experience,
                    jobType: employee.jobType,
                    jobTitle: employee.jobTitle,
                    seniority: employee.seniority,
                    salary: employee.salary,
                    status: interest.status,
                    applicationDate: interest.applicationDate
                )
            }
            
            self.jobApplications = datajobApplications
        }
    }
}

// Preview
#Preview {
     @Previewable @State var isVisible  = false
    AppliedJobsView(isVisible: $isVisible)
}
