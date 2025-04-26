import SwiftUI

struct NavBarView: View {
    
    let CurrentPageColor = Color.secondary
    let CurrentPageFontColor = Color.backgroundColor
    let deactiveColor = Color.quaternary
    @Binding var selectedTab: Int
    @Binding var isVisible: Bool
    var body: some View {
        if(isVisible){

            ZStack {
                HStack {
                    
                    
                    Spacer()
                    
                    // Main Tab
                    VStack {
                        Image(systemName: "house")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(selectedTab == 0 ? .primaryColor : .gray)
                    }
                    .onTapGesture {
                        selectedTab = 0
                    }
                    
                    Spacer()
                    VStack{
                        Image(systemName: "list.bullet").resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(selectedTab == 1 ? .primaryColor : .gray)
                    }.onTapGesture {
                        selectedTab = 1
                    }
                    Spacer()
                    // Chat Tab
                    VStack {
                        Image(systemName: "message")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(selectedTab == 2 ? .primaryColor : .gray)
                    }
                    .onTapGesture {
                        selectedTab = 2
                    }
                    
                    Spacer()
                    
                    // Profile Tab
                    VStack {
                        Image(systemName: "person")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(selectedTab == 3 ? .primaryColor : .gray)
                    }
                    .onTapGesture {
                        selectedTab = 3
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color.backgroundColor)
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
            }.background(Color.secondaryColor)
        }
           
    }
}

struct TestView: View {
    var body: some View {
        Text("This is the Test View")
            .navigationBarTitle("Test", displayMode: .inline)
    }
}


struct MessagesView: View {
    var body: some View {
        Text("This is the Messages View")
            .navigationBarTitle("Messages", displayMode: .inline)
        Spacer()
    }
}
