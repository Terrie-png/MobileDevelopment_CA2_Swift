import SwiftUI
import SwiftData

struct CardStackView: View {
    
    @Environment(\.modelContext) var modelContext
    var controller: EmployeeController = EmployeeController.shared
    var interestedController: InterestedEmployeeController = InterestedEmployeeController.shared
    var authController: AuthController = AuthController.shared
    @State private var employees: [Employee] = []
    
    var body: some View {
        VStack {
            if !employees.isEmpty {
                let cards = employees.map { employee in
                    CardView.Model(
                        id: employee.id,
                        profileImage: employee.profileImage,
                        name: employee.name,
                        rating: employee.rating,
                        location: employee.location,
                        experience: employee.experience,
                        jobType: employee.jobType,
                        jobTitle: employee.jobTitle,
                        seniority: employee.seniority,
                        salary: employee.salary
                    )
                }
                
                let model = SwipeableCardsView.Model(cards: cards)
                
                SwipeableCardsView(model: model) { model in
                    print(model.swipedCards)
                    model.reset()
                }
            } else {
                Text("Loading employees...")
                    .padding()
            }
        }
        .onAppear {
            loadEmployees()
        }
    }
    
    private func loadEmployees() {
        guard let fetched = controller.getAllEmployees(context: modelContext), !fetched.isEmpty else {
            controller.insertSampleEmployees(context: modelContext)
            employees = controller.getAllEmployees(context: modelContext) ?? []
            return
        }

        // Build a set of all interested employee IDs
        
            guard let ownerId = authController.getLoggedInID() else{
                print("User Not logged In!!")
                return
            }
        let interested = interestedController.getAllInterestedEmployees(context: modelContext, ownerId: ownerId)
        let interestedIDs = Set(interested?.compactMap { $0.id } ?? [])

        employees = fetched.filter { employee in
            guard employee.id != nil else { return false }
            return !interestedIDs.contains(employee.id)
        }
    }

    

}

#Preview {
    CardStackView()
}
