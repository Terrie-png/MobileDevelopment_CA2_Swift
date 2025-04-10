//
//  CardStackView.swift
//  Mobile Development CA2
//
//  Created by Student on 20/03/2025.
//
import CoreLocation
import SwiftUI

struct CardStackView: View {
    @Binding var  selectedLocation: CLLocationCoordinate2D?
    @Binding var  searchRadius: Double?
    var body: some View {
        VStack {
//            let cards = [
//                CardView.Model( profileImage: "", // Replace with actual asset name
//                                name: "Chelsea Knight",
//                                rating: "4.8",
//                                location: "New York",
//                                experience: "3+ year",
//                                jobType: "Full-time",
//                                jobTitle: "Hardware Engineer",
//                                seniority: "Senior",
//                                salary: "$2400 / month"),
//                CardView.Model( profileImage: "", // Replace with actual asset name
//                                name: "Chelsea Knight",
//                                rating: "4.8",
//                                location: "New York",
//                                experience: "3+ year",
//                                jobType: "Full-time",
//                                jobTitle: "Hardware Engineer",
//                                seniority: "Senior",
//                                salary: "$2400 / month"),
//                CardView.Model( profileImage: "", // Replace with actual asset name
//                                name: "Chelsea Knight",
//                                rating: "4.8",
//                                location: "New York",
//                                experience: "3+ year",
//                                jobType: "Full-time",
//                                jobTitle: "Hardware Engineer",
//                                seniority: "Senior",
//                                salary: "$2400 / month"),
//                CardView.Model( profileImage: "", // Replace with actual asset name
//                                name: "Chelsea Knight",
//                                rating: "4.8",
//                                location: "New York",
//                                experience: "3+ year",
//                                jobType: "Full-time",
//                                jobTitle: "Hardware Engineer",
//                                seniority: "Senior",
//                                salary: "$2400 / month"),
//                CardView.Model( profileImage: "", // Replace with actual asset name
//                                name: "Chelsea Knight",
//                                rating: "4.8",
//                                location: "New York",
//                                experience: "3+ year",
//                                jobType: "Full-time",
//                                jobTitle: "Hardware Engineer",
//                                seniority: "Senior",
//                                salary: "$2400 / month")
//            ]
            let cards = EmployeeSamples
            let filtered = selectedLocation != nil
                ? filterEmployeesWithinRadius(
                    employees: EmployeeSamples,
                    from: selectedLocation!,
                    from: searchRadius!
                  )
                : EmployeeSamples
            let model = SwipeableCardsView.Model(cards: cards)
            SwipeableCardsView(model: model) { model in
                print(model.swipedCards)
                model.reset()
            }
        }
    }
    func filterEmployeesWithinRadius(
        employees: [CardView.Model],
        from centerCoordinate: CLLocationCoordinate2D,
        from radiusKm: Double
    ) -> [CardView.Model] {
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude,
                                       longitude: centerCoordinate.longitude)
        
        return employees.filter { employee in
            let employeeLocation = CLLocation(latitude: employee.coordinates.latitude,
                                             longitude: employee.coordinates.longitude)
            let distance = centerLocation.distance(from: employeeLocation) / 1000 // Convert to kilometers
            return distance <= radiusKm
        }
    }
}
#Preview {
//    CardStackView()
}
