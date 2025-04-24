import SwiftUI

struct SplashView: View {
    @State private var isActive = false

    @State var isloggedIn:Bool = false
    var authController = AuthController.shared
    var body: some View {
        if isActive {
            if(isloggedIn){
                CompiledMainPageView(isLoggedIn: $isloggedIn)
            } else{
                LoginView(isLoggedIn: $isloggedIn)
            }
        } else {
            ZStack {
                Color(red: 255/255, green: 255/255, blue: 245/255)
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding()

                }
            }
            .onAppear {
                // Splash delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
