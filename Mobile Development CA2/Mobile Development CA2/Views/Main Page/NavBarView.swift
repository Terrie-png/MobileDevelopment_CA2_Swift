import SwiftUI

struct NavBarView: View {
    
    let CurrentPageColor = Color.secondary
    let CurrentPageFontColor = Color.backgroundColor
    let deactiveColor = Color.quaternary
    @Binding var selectedTab: Int
    var body: some View {
//        
//        ZStack {
//            // Background shape
//            RoundedRectangle(cornerRadius: 25)
//                .fill(Color.quaternary) // Adjust color as needed
//                .frame(height: 80)
//                .padding(.horizontal, 20)
//                .shadow(radius: 5)
//
//            HStack(spacing: 40) {
//                
//                // First button with NavigationLink
//                NavigationLink(destination: TestView()) {
//                    Button(action: {
//                        // Action for first button
//                        print("Pressed");
//                    }) {
//                        Image(systemName: "briefcase.fill")
//                            .foregroundColor(.white)
//                            .font(.system(size: 24))
//                    }
//                }
//                
//                // Middle "Search" button
//                ZStack {
//                    Capsule()
//                        .fill(Color.secondaryColor)
//                        .frame(width: 100, height: 45)
//                    
//                    HStack {
//                        Image(systemName: "magnifyingglass")
//                            .foregroundColor(Color.backgroundColor)
//                        Text("Search")
//                            .foregroundColor(Color.backgroundColor)
//                            .font(.system(size: 16, weight: .bold))
//                    }
//                }
//                
//                // Second button with NavigationLink
//                NavigationLink(destination: ProfileView()) {
//                    Button(action: {
//                        // Action for second button
//                    }) {
//                        Image(systemName: "person.fill")
//                            .foregroundColor(.white)
//                            .font(.system(size: 24))
//                    }
//                }
//                
//                // Third button with NavigationLink
//                NavigationLink(destination: MessagesView()) {
//                    Button(action: {
//                        // Action for third button
//                    }) {
//                        Image(systemName: "bubble.left.and.bubble.right.fill")
//                            .foregroundColor(.white)
//                            .font(.system(size: 24))
//                    }
//                }
//            }
//            .padding(.bottom, 10)
        HStack {
                    Spacer()

                    // Main Tab
                    VStack {
                        Image(systemName: "house")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(selectedTab == 0 ? .blue : .gray)
                    }
                    .onTapGesture {
                        selectedTab = 0
                    }

                    Spacer()

                    // Chat Tab
                    VStack {
                        Image(systemName: "message")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(selectedTab == 1 ? .blue : .gray)
                    }
                    .onTapGesture {
                        selectedTab = 1
                    }

                    Spacer()

                    // Profile Tab
                    VStack {
                        Image(systemName: "person")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(selectedTab == 2 ? .blue : .gray)
                    }
                    .onTapGesture {
                        selectedTab = 2
                    }

                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
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
        Spacer()
    }
}

#Preview {
    Contentview1()
}

struct Contentview1: View{
    @State private var selectedTab = 0
    
    var body : some View{
        ZStack{
            switch selectedTab {
            case 0:
                TestView()
                
            case 1:
                MessagesView()
            case 2:
                ProfileView()
            default:
                TestView()
            }
            
        }
        
        VStack{
            Spacer()
            NavBarView(selectedTab: $selectedTab)
        }
    }
}

