
import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack{
            Color.primary.frame(height: 200)
            CircleImageView()
                            .frame(width: 200, height: 200)
                            .offset(y: -130) .padding(.bottom, -130)
            VStack() {
                Divider()
                NavigationLink(destination:test()){
                    HStack{
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
                }
                    Divider()
                NavigationLink(destination:test()){
                    HStack{
                        Image(systemName: "accessibility")
                        Text("Accessibility")
                    }
                }
                    Divider()
                    HStack(spacing: 15) {
                        Button(action: {
                            // Withdraw Application
                        }) {
                            Text("Log Out")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.top)
                }
                       }
                       .padding()


                       Spacer()
            
        
        
    }
}

#Preview {
    ProfileView()
}

