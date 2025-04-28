import SwiftUI

// Applied Jobs View
struct AppliedJobsView: View {
    // Updated sample job applications to match the new structure
    @State var jobApplications: [JobApplication] = []
    @Binding var isVisible: Bool

    @Environment(\.modelContext) var modelContext
    var controller = InterestedEmployeeController.shared
    var employeeController = EmployeeController.shared
    var authController = AuthController.shared
    @Environment(\.notificationService) var notificationService

    var body: some View {
        ZStack {
            Color.secondaryColor
                .ignoresSafeArea()

            if jobApplications.isEmpty {
                // Empty state
                VStack {
                    Spacer()
                    Text("No Data Found.\nPlease try again later...")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding()
                    Spacer()
                }
            } else {
                // Populated list
                List(jobApplications) { application in
                    NavigationLink(
                        destination: JobApplicationDetailView(
                            jobApplication: application,
                            isVisible: $isVisible
                        )
                    ) {
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
                    .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
            }
        }
        .onAppear {
            resetNotificationPermissions()
            
            let allEmployees = employeeController.getAllEmployees(context: modelContext) ?? []

            guard let ownerId = authController.getLoggedInID() else {
                print("User Not logged In!!")
                return
            }
            let interestedList = controller.getAllInterestedEmployees(
                context: modelContext,
                ownerId: ownerId
            ) ?? []

            let employeeDict = Dictionary(
                uniqueKeysWithValues: allEmployees.map { ($0.id, $0) }
            )

            let datajobApplications: [JobApplication] = interestedList.compactMap { interest in
                guard let employee = employeeDict[interest.id] else { return nil }
                return JobApplication(
                    id: employee.id,
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
    func resetNotificationPermissions() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removeObject(forKey: "\(bundleID).notificationSettings")
        }
    }
    
}

// Preview
#Preview {
    @Previewable @State var isVisible = false
    AppliedJobsView(isVisible: $isVisible)
}
