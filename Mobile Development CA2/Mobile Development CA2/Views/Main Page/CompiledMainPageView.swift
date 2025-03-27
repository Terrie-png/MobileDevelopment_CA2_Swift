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
        HeaderView(title: $title, isVisible: $isVisible)
        NavigationView{
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
                    MessagesView().onAppear{
                        title = "Chats"
                        isVisible = true
                    }
                case 3:
                    ProfileView().onAppear{
                        title = "Profile"
                        isVisible = true
                    }
                default:
                    TestView()
                }
            }
            
        }
        
        VStack{
            NavBarView(selectedTab: $selectedTab, isVisible: $isVisible)
        }
    }
}

#Preview {
    CompiledMainPageView()
}
