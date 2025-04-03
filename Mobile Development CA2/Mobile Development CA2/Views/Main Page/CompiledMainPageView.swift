//
//  CompiledMainPageView.swift
//  Mobile Development CA2
//
//  Created by Student on 20/03/2025.
//

import SwiftUI

struct CompiledMainPageView: View {
    @State private var selectedTab = 0
    @State private var title = "Search Jobs"
    @State private var isVisible = true
    var body : some View{
        HeaderView(title: $title,selectedTab: $selectedTab, isVisible: $isVisible)

        NavigationStack{
            ZStack{
                switch selectedTab {
                case 0:
                    
                    CardStackView().onAppear{
                        title = "Search Jobs"
                        isVisible = true
                    }
                    
                case 1:
                    AppliedJobsView(isVisible: $isVisible).onAppear{
                        title = "Jobs Applied"
                        isVisible = true
                    }
                case 2:
                    ChatView(users: [
                        User(profileImage: "system:person.crop.circle.fill",
                             name: "Alice",
                             lastMessage: "Hey, how are you?",
                             time: "10:30 AM"),
                        
                        User(profileImage: "system:person.crop.circle",
                             name: "Bob",
                             lastMessage: "Meeting at 3 PM",
                             time: "Yesterday"),
                        
                        User(profileImage: "system:person.2.circle.fill",
                             name: "Team Group",
                             lastMessage: "Project update",
                             time: "2 days ago")
                    ],isVisible: $isVisible).onAppear{
                        title = "Chats"
                        isVisible = true
                    }
                case 3:
                    ProfileView().onAppear{
                        title = "Profile"
                        isVisible = true
                    }
                default:
                    CardStackView().onAppear{
                        title = "Search Jobs"
                        isVisible = true
                    }
                }
            }
            

            
        }.background(Color.secondaryColor)
            NavBarView(selectedTab: $selectedTab, isVisible: $isVisible)
    }
}

#Preview {
    CompiledMainPageView()
}
