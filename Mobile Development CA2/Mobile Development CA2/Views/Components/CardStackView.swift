import SwiftUI
import SwiftData

struct CardStackView: View {
    
    @Environment(\.modelContext) var modelContext
    var controller: EmployeeController = EmployeeController.shared
    var interestedController: InterestedEmployeeController = InterestedEmployeeController.shared
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
            insertSampleEmployees()
            employees = controller.getAllEmployees(context: modelContext) ?? []
            return
        }

        // Build a set of all interested employee IDs
        let interested = interestedController.getAllInterestedEmployees(context: modelContext)
        let interestedIDs = Set(interested?.compactMap { $0.id } ?? [])

        employees = fetched.filter { employee in
            guard employee.id != nil else { return false }
            return !interestedIDs.contains(employee.id)
        }
    }

    
    private func insertSampleEmployees() {
        for sample in EmployeeSamples {
            let employee = Employee(
                profileImage: sample.profileImage,
                name: sample.name,
                rating: sample.rating,
                location: sample.location,
                experience: sample.experience,
                jobType: sample.jobType,
                jobTitle: sample.jobTitle,
                seniority: sample.seniority,
                salary: sample.salary
            )
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
