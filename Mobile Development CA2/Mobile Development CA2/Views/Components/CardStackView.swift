import SwiftUI
import SwiftData

struct CardStackView: View {
    @Environment(\.modelContext) var modelContext
    var controller: EmployeeController = EmployeeController.shared
    var interestedController: InterestedEmployeeController = InterestedEmployeeController.shared
    @State private var employees: [Employee] = []
    @State private var isLoading = true
    
    // Filter bindings
    @Binding var selectedJobTypes: Set<String>
    @Binding var selectedLocations: Set<String>
    @Binding var selectedSeniorities: Set<String>
    @Binding var selectedJobTitles: Set<String>
    
    // Computed property for filtered employees
    private var filteredEmployees: [Employee] {
        guard !employees.isEmpty else { return [] }
        
        // If no filters are selected, return all employees
        if selectedJobTypes.isEmpty &&
            selectedLocations.isEmpty &&
            selectedSeniorities.isEmpty &&
            selectedJobTitles.isEmpty {
            return employees
        }
        
        return employees.filter { employee in
            // Job Type filter
            if !selectedJobTypes.isEmpty {
                if !selectedJobTypes.contains(employee.jobType) {
                    return false
                }
            }
            
            // Location filter
            if !selectedLocations.isEmpty {
                if !selectedLocations.contains(employee.location) {
                    return false
                }
            }
            
            // Seniority filter
            if !selectedSeniorities.isEmpty {
                if !selectedSeniorities.contains(employee.seniority) {
                    return false
                }
            }
            
            // Job Title filter (case insensitive)
            if !selectedJobTitles.isEmpty {
                let lowercasedTitle = employee.jobTitle.lowercased()
                if !selectedJobTitles.contains { $0.lowercased() == lowercasedTitle } {
                    return false
                }
            }
            
            return true
        }
    }
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading employees...")
                    .padding()
            } else if filteredEmployees.isEmpty {
                Text("No employees match your filters")
                    .padding()
            } else {
                let cards = filteredEmployees.map { employee in
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
            }
        }
        .onAppear {
            loadEmployees()
        }
        .onChange(of: selectedJobTypes) { _ in applyFilters() }
        .onChange(of: selectedLocations) { _ in applyFilters() }
        .onChange(of: selectedSeniorities) { _ in applyFilters() }
        .onChange(of: selectedJobTitles) { _ in applyFilters() }
    }
    
    private func loadEmployees() {
        isLoading = true
        let fetched = controller.getAllEmployees(context: modelContext)
        let interested = interestedController.getAllInterestedEmployees(context: modelContext)
        
        if let fetched = fetched, !fetched.isEmpty {
            // Build a set of all interested employee IDs
            let interestedIDs = Set(interested?.map { $0.id } ?? [])
            
            // Filter out employees whose IDs are already in interestedIDs
            employees = fetched.filter { !interestedIDs.contains($0.id) }
        } else {
            controller.insertSampleEmployees(context: modelContext)
            employees = controller.getAllEmployees(context: modelContext) ?? []
            return
        }
        

        let interestedIDs = Set(interested?.compactMap { $0.id } ?? [])

//        
//        employees = fetched.filter { employee in
//            guard employee.id != nil else { return false }
//            return !interestedIDs.contains(employee.id)
        isLoading = false
    }
     func applyFilters() {
           // Filters are automatically applied through the filteredEmployees computed property
       }
    

}

// Preview with sample bindings
struct CardStackView_Previews: PreviewProvider {
    @State static var jobTypes: Set<String> = ["Full-time"]
    @State static var locations: Set<String> = ["New York"]
    @State static var seniorities: Set<String> = []
    @State static var jobTitles: Set<String> = []
    
    static var previews: some View {
        CardStackView(
            selectedJobTypes: $jobTypes,
            selectedLocations: $locations,
            selectedSeniorities: $seniorities,
            selectedJobTitles: $jobTitles
        )
    }
}
