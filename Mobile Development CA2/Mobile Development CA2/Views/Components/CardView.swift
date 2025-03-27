import SwiftUI

struct CardView: View {
    enum SwipeDirection {
        case left, right, none
    }

    struct Model: Identifiable, Equatable {
        let id = UUID()
        let text: String
        var swipeDirection: SwipeDirection = .none
    }

    var model: Model
    var size: CGSize
    var dragOffset: CGSize
    var isTopCard: Bool
    var isSecondCard: Bool

    var body: some View {
        Text(model.text)
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

            .frame(width: size.width * 0.8, height: size.height * 0.8)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: isTopCard ? getShadowColor() : (isSecondCard && dragOffset.width != 0 ? Color.gray.opacity(0.2) : Color.clear), radius: 10, x: 0, y: 3)
            .foregroundColor(.black)
            .font(.largeTitle)
            .padding()
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

