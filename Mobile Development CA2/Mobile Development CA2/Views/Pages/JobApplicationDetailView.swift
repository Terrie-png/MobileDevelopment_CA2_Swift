import SwiftUI

struct JobApplicationDetailView: View {
    let jobApplication: JobApplication
    @Binding var isVisible: Bool
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext

    // Controllers
    var authController: AuthController = .shared
    var interestedController: InterestedEmployeeController = .shared

    // State for showing the withdrawal confirmation alert
    @State private var showWithdrawalConfirmation = false

    var body: some View {
        ZStack {
            Color.secondaryColor.ignoresSafeArea()

            VStack(spacing: 0) {
                // Custom Back Button
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(Color.clear)

                // Scrollable Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Job Header
                        VStack(alignment: .leading, spacing: 10) {
                            Text(jobApplication.name)
                                .font(.title)
                                .fontWeight(.bold)

                            Text(jobApplication.jobTitle)
                                .font(.headline)
                                .foregroundColor(.secondary)

                            // Status Tag
                            Text(jobApplication.status.rawValue)
                                .font(.caption)
                                .padding(6)
                                .background(jobApplication.status.statusColor)
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }
                        .padding(.bottom)

                        // Job Details
                        Group {
                            DetailRow(
                                icon: "briefcase",
                                title: "Job Type",
                                value: jobApplication.jobType
                            )
                            DetailRow(
                                icon: "star",
                                title: "Seniority",
                                value: jobApplication.seniority
                            )
                            DetailRow(
                                icon: "location",
                                title: "Location",
                                value: jobApplication.location
                            )
                            DetailRow(
                                icon: "clock",
                                title: "Experience",
                                value: jobApplication.experience
                            )
                            DetailRow(
                                icon: "dollarsign.circle",
                                title: "Salary",
                                value: jobApplication.salary
                            )
                            DetailRow(
                                icon: "calendar",
                                title: "Application Date",
                                value: formatDate(jobApplication.applicationDate)
                            )
                        }

                        // Action Buttons
                        HStack(spacing: 15) {
                            Button(action: {
                                // Trigger confirmation alert
                                showWithdrawalConfirmation = true
                            }) {
                                Text("Withdraw")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            NavigationLink {
                                ChatDetailView(
                                    isVisible: $isVisible, employeeId: jobApplication.id
                                )
                            } label: {
                                Text("Chat")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }

                        }
                        .padding(.top)
                    }
                    .padding()
                    .background(Color.clear)
                }
            }
            .onAppear {
                isVisible = false
            }
            .navigationBarHidden(true)
            // Confirmation Alert
            .alert(
                "Confirm Withdrawal",
                isPresented: $showWithdrawalConfirmation
            ) {
                Button("Withdraw", role: .destructive) {
                    guard let ownerId = authController.getLoggedInID() else {
                        print("User Not logged In!!")
                        return
                    }
                    if let _ = interestedController.deleteInterestedEmployee(
                        employeeId: jobApplication.id,
                        ownerId: ownerId,
                        context: modelContext
                    ) {
                        // Dismiss view upon successful withdrawal
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        // Handle failure if needed
                        print("Failed to withdraw application")
                    }
                }
                Button("Cancel", role: .cancel) { }
            }
        }
    }

    // Date Formatter
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}


