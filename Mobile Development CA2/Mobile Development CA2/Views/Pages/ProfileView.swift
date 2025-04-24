
import SwiftUI

struct ProfileView: View {
    @Binding var isVisible : Bool
    
    var body: some View {
        ZStack{
            Color.secondaryColor.ignoresSafeArea()
            
            VStack{
                Color.primary.frame(height: 200)
                CircleImageView()
                                .frame(width: 200, height: 200)
                                .offset(y: -130) .padding(.bottom, -130)
                VStack() {
    //                NavigationLink(destination:test()){
    //                    HStack{
    //                        Image(systemName: "square.and.arrow.up")
    //                        Text("Upload Resume")
    //                    }
    //                }

                    Divider().background(Color.secondaryColor)
                    NavigationLink(destination:LocationSettingsView(isVisible: $isVisible)){
                        HStack{
                            Image(systemName: "location.circle.fill").foregroundColor(Color.blue)
                            Text("Location")
                        }
                    }
                        Divider()
                    NavigationLink(destination:test()){
                        HStack{
                            Image(systemName: "person.crop.circle")
                            Text("Profile")
                        }
                    }
                        Divider()
                    Spacer()
                        HStack(spacing: 15) {
                            Button(action: {
                                AuthController.shared.logout()
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
}
