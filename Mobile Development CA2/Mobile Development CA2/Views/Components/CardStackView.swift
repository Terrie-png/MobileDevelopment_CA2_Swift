//
//  CardStackView.swift
//  Mobile Development CA2
//
//  Created by Student on 20/03/2025.
//

import SwiftUI

struct CardStackView: View {
    var body: some View {
        VStack {
            let cards = [
                CardView.Model( profileImage: "", // Replace with actual asset name
                                name: "Chelsea Knight",
                                rating: "4.8",
                                location: "New York",
                                experience: "3+ year",
                                jobType: "Full-time",
                                jobTitle: "Hardware Engineer",
                                seniority: "Senior",
                                salary: "$2400 / month"),
                CardView.Model( profileImage: "", // Replace with actual asset name
                                name: "Chelsea Knight",
                                rating: "4.8",
                                location: "New York",
                                experience: "3+ year",
                                jobType: "Full-time",
                                jobTitle: "Hardware Engineer",
                                seniority: "Senior",
                                salary: "$2400 / month"),
                CardView.Model( profileImage: "", // Replace with actual asset name
                                name: "Chelsea Knight",
                                rating: "4.8",
                                location: "New York",
                                experience: "3+ year",
                                jobType: "Full-time",
                                jobTitle: "Hardware Engineer",
                                seniority: "Senior",
                                salary: "$2400 / month"),
                CardView.Model( profileImage: "", // Replace with actual asset name
                                name: "Chelsea Knight",
                                rating: "4.8",
                                location: "New York",
                                experience: "3+ year",
                                jobType: "Full-time",
                                jobTitle: "Hardware Engineer",
                                seniority: "Senior",
                                salary: "$2400 / month"),
                CardView.Model( profileImage: "", // Replace with actual asset name
                                name: "Chelsea Knight",
                                rating: "4.8",
                                location: "New York",
                                experience: "3+ year",
                                jobType: "Full-time",
                                jobTitle: "Hardware Engineer",
                                seniority: "Senior",
                                salary: "$2400 / month")
            ]
            
            let model = SwipeableCardsView.Model(cards: cards)
            SwipeableCardsView(model: model) { model in
                print(model.swipedCards)
                model.reset()
            }
        }
        .padding()
    }
}
#Preview {
    CardStackView()
}
