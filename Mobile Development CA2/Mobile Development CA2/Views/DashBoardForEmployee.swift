//
//  DashBoardForEmployee.swift
//  Mobile Development CA2
//
//  Created by Student on 13/03/2025.
//

import SwiftUI

struct DashBoardForEmployee: View {
//    @State private var freelancers: [CardsForEmployee] = [
//        CardsForEmployee( profileImage: "ProfilePicture", // Replace with actual asset name
//                          name: "Chelsea Knight",
//                          rating: "4.8",
//                          location: "New York",
//                          experience: "3+ year",
//                          jobType: "Full-time",
//                          jobTitle: "Hardware Engineer",
//                          seniority: "Senior",
//                          salary: "$2400 / month"),
//        CardsForEmployee( profileImage: "ProfilePicture", // Replace with actual asset name
//                          name: "Chelsea Knight",
//                          rating: "4.8",
//                          location: "New York",
//                          experience: "3+ year",
//                          jobType: "Full-time",
//                          jobTitle: "Hardware Engineer",
//                          seniority: "Senior",
//                          salary: "$2400 / month"),
//        CardsForEmployee( profileImage: "ProfilePicture", // Replace with actual asset name
//                          name: "Chelsea Knight",
//                          rating: "4.8",
//                          location: "New York",
//                          experience: "3+ year",
//                          jobType: "Full-time",
//                          jobTitle: "Hardware Engineer",
//                          seniority: "Senior",
//                          salary: "$2400 / month"),
//        CardsForEmployee( profileImage: "ProfilePicture", // Replace with actual asset name
//                          name: "Chelsea Knight",
//                          rating: "4.8",
//                          location: "New York",
//                          experience: "3+ year",
//                          jobType: "Full-time",
//                          jobTitle: "Hardware Engineer",
//                          seniority: "Senior",
//                          salary: "$2400 / month")
//        ]
    var body: some View {
            VStack(spacing: 10) {
                // 🔍 Header Section
                SearchHeaderView()

                // 👤 Freelancer List (from another folder)
//                ZStack {
//                                ForEach(freelancers.indices.reversed(), id: \.self) { index in
//                                    freelancers[index]
//                                        .offset(x: freelancers[index].offset)
//                                        .rotationEffect(.degrees(freelancers[index].offset / 10))
//                                        .gesture(
//                                            DragGesture()
//                                                .onChanged { gesture in
//                                                    freelancers[index].offset = gesture.translation.width
//                                                }
//                                                .onEnded { gesture in
//                                                    if abs(gesture.translation.width) > 120 {
//                                                        withAnimation {
//                                                            freelancers[index].offset = gesture.translation.width > 0 ? 500 : -500
//                                                        }
//                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                                            freelancers.remove(at: index)
//                                                        }
//                                                    } else {
//                                                        withAnimation {
//                                                            freelancers[index].offset = 0
//                                                        }
//                                                    }
//                                                }
//                                        )
//                                }
//                            }

                // 🔽 Bottom Navigation Bar (from another folder)
                BottomNavBar()
            }
            .edgesIgnoringSafeArea(.bottom)
        }
}
struct SearchHeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Search")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.black)

                Text("Jobs")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.black.opacity(0.8))
            }

            Spacer()

            Button(action: {
                print("Filter button tapped")
            }) {
                HStack {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.black)
                    Text("Filters")
                        .foregroundColor(.black)
                }
                .padding(12)
                .background(Color.white)
                .clipShape(Capsule())
                .shadow(radius: 2)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    DashBoardForEmployee()
}
