import SwiftUI
import SwiftData
extension Double {
    var degreesToRadians: Double { return self * .pi / 180 }
    var radiansToDegrees: Double { return self * 180 / .pi }
}
struct CardStackView: View {
    @Environment(\.modelContext) var modelContext
    var controller: EmployeeController = EmployeeController.shared
    var interestedController: InterestedEmployeeController = InterestedEmployeeController.shared
    var authController: AuthController = AuthController.shared
    var userController: UserController = UserController.shared
   
    
    @State private var employees: [Employee] = []
    @State private var isLoading = true
   
    @State private var userLatittude :Double = 0
    @State private var userLongitutde :Double = 0
    // Filter bindings
    @Binding var selectedJobTypes: Set<String>
    @Binding var selectedLocations: Set<String>
    @Binding var selectedSeniorities: Set<String>
    @Binding var selectedJobTitles: Set<String>
    
    // Computed property for filtered employees
    private var filteredEmployees: [Employee] {
        guard !employees.isEmpty else { return [] }
        
        // First apply all filters
        var filtered = employees.filter { employee in
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
        
        // If no filters are selected, use all employees
        if selectedJobTypes.isEmpty &&
            selectedLocations.isEmpty &&
            selectedSeniorities.isEmpty &&
            selectedJobTitles.isEmpty {
            filtered = employees
        }
        
        // Sort by distance if user location is available
        if userLatittude != 0 && userLongitutde != 0 {
            filtered.sort { emp1, emp2 in
                let distance1 = calculateDistance(from: (userLatittude, userLongitutde),
                                               to: (emp1.geoLatitude, emp1.geoLongitude))
                let distance2 = calculateDistance(from: (userLatittude, userLongitutde),
                                               to: (emp2.geoLatitude, emp2.geoLongitude))
                return distance1 < distance2
            }
        }
        
        return filtered
    
        
    }
    private func calculateDistance(from: (Double, Double), to: (Double, Double)) -> Double {
        let earthRadius = 6371000.0 // meters
        
        let lat1 = from.0.degreesToRadians
        let lon1 = from.1.degreesToRadians
        let lat2 = to.0.degreesToRadians
        let lon2 = to.1.degreesToRadians
        
        let dLat = lat2 - lat1
        let dLon = lon2 - lon1
        
        let a = sin(dLat/2) * sin(dLat/2) +
                cos(lat1) * cos(lat2) *
                sin(dLon/2) * sin(dLon/2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        
        return earthRadius * c
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
      
    }
    
    
    private func loadEmployees() {
        
        isLoading = true
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
            let userLocation = authController.getUserModel(modelContext: modelContext)
        userLatittude = userLocation?.geoLatitude ?? 0
        userLongitutde = userLocation?.geoLongitude ?? 0
        
            let interestedIDs = Set(interested?.compactMap { $0.id } ?? [])

            employees = fetched.filter { employee in
                guard employee.id != nil else { return false }
                return !interestedIDs.contains(employee.id)
            }
        
        isLoading = false
        }
   
    

}
