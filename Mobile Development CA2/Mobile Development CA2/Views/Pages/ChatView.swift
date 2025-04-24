import SwiftUI

// User model remains the same
struct User: Identifiable {
    let id = UUID()
    let profileImage: String
    let name: String
    let lastMessage: String?
    let time: String?
}



struct ChatView: View {
    @Environment(\.modelContext) var modelContext
//    @StateObject private var chatController: ChatMessageController

   
    var employeeController = EmployeeController.shared
    var inrestedEmployee = InterestedEmployeeController.shared
    @State private var interestedEmployees: [InterestedEmployee] = []
      var users: [User]
    @State private var isLoading = false
    @State private var errorMessage: String?
//    init() {
//        _chatController = StateObject(wrappedValue: ChatMessageController(modelContext: modelContext))
//    }
  
    @Binding var isVisible:Bool
    var body: some View {

        ZStack {
            Color.secondaryColor
                    .ignoresSafeArea()
            
            List(users) { user in
                NavigationLink(destination: ChatDetailView(user: user,isVisible:$isVisible)) {
                    HStack(spacing: 12) {
                        // Profile Image
                        if user.profileImage.hasPrefix("system:") {
                            Image(systemName: String(user.profileImage.dropFirst(7)))
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.blue)
                        } else {
                            Image(user.profileImage)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.name)
                                .font(.headline)
                            if let lastMessage = user.lastMessage {
                                Text(lastMessage)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        if let time = user.time {
                            Text(time)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                    
                    
                }.listRowBackground(Color.clear)
                .swipeActions {
                    Button("Delete", role: .destructive) {
                        // Handle delete action
                    }
                }
            }
            .listStyle(.plain)
            
            
        }
        
        
    }
    private func fetchInterestedEmployees() async {
            isLoading = true
            errorMessage = nil
            
            do {
               
                let allEmployees = employeeController.getAllEmployees(context: modelContext) ?? []
                let interestedEmployees = inrestedEmployee.getAllInterestedEmployees(context: modelContext) ?? []
                let employeeDict = Dictionary(uniqueKeysWithValues: allEmployees.map { ($0.id, $0)})
                var datajobApplications: [JobApplication] = interestedEmployees.compactMap { interest in
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
            }
            
            isLoading = false
        }
}


//// Preview
//#Preview {
//
//    @Previewable @State var isVisible  = false
//
//    NavigationView{
////        ChatView(users: [
////            User(profileImage: "system:person.crop.circle.fill",
////                 name: "Alice",
////                 lastMessage: "Hey, how are you?",
////                 time: "10:30 AM"),
////            
////            User(profileImage: "system:person.crop.circle",
////                 name: "Bob",
////                 lastMessage: "Meeting at 3 PM",
////                 time: "Yesterday"),
////            
////            User(profileImage: "system:person.2.circle.fill",
////                 name: "Team Group",
////                 lastMessage: "Project update",
////                 time: "2 days ago")
////        ],isVisible: $isVisible)
//    }
//}
