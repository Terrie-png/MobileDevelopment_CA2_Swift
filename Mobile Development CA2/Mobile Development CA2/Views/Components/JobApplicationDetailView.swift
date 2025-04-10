//
//  JobApplicationDetailView.swift
//  Mobile Development CA2
//
//  Created by Student on 28/03/2025.
//

import SwiftUI
struct JobApplicationDetailView: View {
    let jobApplication: JobApplication
    @Binding var isVisible:Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
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
                                // Withdraw Application
                            }) {
                                Text("Withdraw")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.top)
                    }
                    .padding()
                    .background(Color.clear)
                }
            }.onAppear{
                isVisible = false
            }
            .navigationBarHidden(true)
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
 
#Preview {
     @Previewable @State var isVisible  = false
    NavigationView{
        AppliedJobsView(isVisible: $isVisible)
    }

}
