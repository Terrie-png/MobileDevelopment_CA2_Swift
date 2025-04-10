import SwiftUI

struct CardView: View {
    enum SwipeDirection {
        case left, right, none
    }

    struct Model: Identifiable, Equatable {
        let id = UUID()
        
        var swipeDirection: SwipeDirection = .none
        var profileImage: String // Image name
                var name: String
                var rating: String
                var location: String
                var experience: String
                var jobType: String
                var jobTitle: String
                var seniority: String
                var salary: String
    }

    var model: Model
    var size: CGSize
    var dragOffset: CGSize
    var isTopCard: Bool
    var isSecondCard: Bool
    @State var showModal = false
    @State var message = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // Profile Image & Actions
            HStack {
                if(model.profileImage == "")
                {
                    Image.ProfilePicture// Replace with actual asset name
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
            Text(model.name)
                .font(.system(size: 24, weight: .bold))
            
            // Rating & Info Badges
            VStack(spacing: 8) {
                badgeView(icon: "star.fill", text: model.rating)
                badgeView(icon: "mappin.and.ellipse", text: model.location)
                badgeView(icon: "clock.fill", text: model.experience)
                badgeView(icon: "briefcase.fill", text: model.jobType )
            }
            
            // Job Title
            Text(model.jobTitle)
                .foregroundColor(.gray)
                .font(.system(size: 16, weight: .medium))
            
            // Seniority & Salary
            Text(model.jobType)
                .font(.system(size: 22, weight: .bold))
            
            Text(model.salary)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            // See Details Button
            Button(action: {
                // Show modal when button is pressed
                showModal.toggle()
            }) {
                Text("See details")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.primaryColor)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.9))
                    .clipShape(Capsule())
            }
            .padding(.top, 5)
            .sheet(isPresented: $showModal) {
                VStack {
                    HStack{
                        Image.ProfilePicture// Replace with actual asset name
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        Text(model.name)
                            .font(.system(size: 24, weight: .bold))
                        
                    }
                    Text("Enter your message:")
                        .font(.title2)
                        .padding()
                    
                    TextField("Type your message here", text: $message)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Close") {
                        // Close the modal
                        showModal = false
                    }
                    .padding()
                }
            }
        
            .padding(.top, 5)
        }
        .padding(20)
        .background(Color.primaryColor)
        .cornerRadius(30)
        .shadow(color: isTopCard ? getShadowColor() : (isSecondCard && dragOffset.width != 0 ? Color.gray.opacity(0.2) : Color.clear), radius: 10, x: 0, y: 3)
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
    
    private func getShadowColor() -> Color {
        if dragOffset.width > 0 {
            return Color.green.opacity(0.5)
        } else if dragOffset.width < 0 {
            return Color.red.opacity(0.5)
        } else {
            return Color.gray.opacity(0.2)
        }
    }
}


