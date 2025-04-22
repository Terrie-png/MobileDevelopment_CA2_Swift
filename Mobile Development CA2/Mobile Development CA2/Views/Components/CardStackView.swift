import SwiftUI
import SwiftData

struct CardStackView: View {
    
    @Environment(\.modelContext) var modelContext
    var controller: EmployeeController = EmployeeController.shared
    var interestedController: InterestedEmployeeController = InterestedEmployeeController.shared
    @State private var employees: [Employee] = []
    @Binding  var selectedJobTypes: Set<String>
    @Binding  var selectedLocations: Set<String>
    @Binding  var selectedSeniorities: Set<String>
    @Binding  var selectedJobTitles: Set<String>
    
    
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
        let fetched = controller.getAllEmployees(context: modelContext)
        let interested = interestedController.getAllInterestedEmployees(context: modelContext)
        
        if let fetched = fetched, !fetched.isEmpty {
            // Build a set of all interested employee IDs
            let interestedIDs = Set(interested?.map { $0.id } ?? [])
            
            // Filter out employees whose IDs are already in interestedIDs
            let notInterestedEmployees = fetched.filter { !interestedIDs.contains($0.id) }
            
            employees = notInterestedEmployees // Assign filtered employees
        } else {
            insertSampleEmployees()
            employees = controller.getAllEmployees(context: modelContext) ?? []
        }
    }

    
    private func insertSampleEmployees() {
        for employee in EmployeeSamples {
            modelContext.insert(employee)
        }
        do {
            try modelContext.save()
        } catch {
            print("Error inserting sample employees: \(error.localizedDescription)")
        }
    }
}

#Preview {
    CardStackView()
}
