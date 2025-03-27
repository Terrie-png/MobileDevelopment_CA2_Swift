import SwiftUI

struct NavBarView: View {
    
    let CurrentPageColor = Color.secondary
    let CurrentPageFontColor = Color.backgroundColor
    let deactiveColor = Color.quaternary

    var body: some View {
        
        ZStack {
            // Background shape
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.quaternary) // Adjust color as needed
                .frame(height: 80)
                .padding(.horizontal, 20)
                .shadow(radius: 5)

            HStack(spacing: 40) {
                
                // First button with NavigationLink
                NavigationLink(destination: TestView()) {
                    Button(action: {
                        // Action for first button
                        print("Pressed");
                    }) {
                        Image(systemName: "briefcase.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                    }
                }
                
                // Middle "Search" button
                ZStack {
                    Capsule()
                        .fill(Color.secondaryColor)
                        .frame(width: 100, height: 45)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.backgroundColor)
                        Text("Search")
                            .foregroundColor(Color.backgroundColor)
                            .font(.system(size: 16, weight: .bold))
                    }
                }
                
                // Second button with NavigationLink
                NavigationLink(destination: ProfileView()) {
                    Button(action: {
                        // Action for second button
                    }) {
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                    }
                }
                
                // Third button with NavigationLink
                NavigationLink(destination: MessagesView()) {
                    Button(action: {
                        // Action for third button
                    }) {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                    }
                }
            }
            .padding(.bottom, 10)
        }
    }
}

struct TestView: View {
    var body: some View {
        Text("This is the Test View")
            .navigationBarTitle("Test", displayMode: .inline)
    }
}

struct ProfileView: View {
    var body: some View {
        Text("This is the Profile View")
            .navigationBarTitle("Profile", displayMode: .inline)
    }
}

struct MessagesView: View {
    var body: some View {
        Text("This is the Messages View")
            .navigationBarTitle("Messages", displayMode: .inline)
    }
}

#Preview {
    NavBarView()
}
