import SwiftUI

struct CardsForEmployee: View {
    var id :UUID
    var profileImage: String // Image name
        var name: String
        var rating: String
        var location: String
        var experience: String
        var jobType: String
        var jobTitle: String
        var seniority: String
        var salary: String
  
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // Profile Image & Actions
            HStack {
                if(profileImage == "")
                {
                    Image.ProfilePicture// Replace with actual asset name
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
                else{
                    Image(profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
                Spacer()
                
                HStack(spacing: 15) {
                    Button(action: {
                        // Like action
                    }) {
                        
                            
                            Image(systemName: "heart.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 22))
                    }
                    
                }
            }

            // Name
            Text(name)
                .font(.system(size: 24, weight: .bold))

            // Rating & Info Badges
            HStack(spacing: 8) {
                badgeView(icon: "star.fill", text: rating)
                badgeView(icon: "mappin.and.ellipse", text: location)
                badgeView(icon: "clock.fill", text: experience)
                badgeView(icon: "briefcase.fill", text: jobType )
            }

            // Job Title
            Text(jobTitle)
                .foregroundColor(.gray)
                .font(.system(size: 16, weight: .medium))

            // Seniority & Salary
            Text(jobType)
                .font(.system(size: 22, weight: .bold))

            Text(salary)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)

            // See Details Button
            Button(action: {
                // Navigate or show details
            }) {
                Text("See details")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.9))
                    .clipShape(Capsule())
            }
            .padding(.top, 5)
        }
        .padding(20)
        .background(Color.primaryColor)
        .cornerRadius(30)
        .shadow(radius: 5)
        .padding(.horizontal, 20)
    }

    // Badge Component
    private func badgeView(icon: String, text: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.black)
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.white.opacity(0.6))
        .clipShape(Capsule())
    }
}

#Preview {
    CardsForEmployee(
        id: UUID(),
                profileImage: "", // Replace with actual asset name
               name: "Chelsea Knight",
               rating: "4.8",
               location: "New York",
               experience: "3+ year",
               jobType: "Full-time",
               jobTitle: "Hardware Engineer",
               seniority: "Senior",
               salary: "$2400 / month"
    )
}
