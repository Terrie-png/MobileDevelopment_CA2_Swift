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
    @State private var isHeaderVisible = true
    var body : some View{
        HeaderView(title: $title, isVisible: $isHeaderVisible)
        NavigationView{
            ZStack{
                switch selectedTab {
                case 0:
                    
                    CardStackView().onAppear{
                        title = "Search Jobs"
                        isHeaderVisible = true
                    }
                    
                case 1:
                    AppliedJobsView(isVisible: $isHeaderVisible).onAppear{
                        title = "Jobs Applied"
                        isHeaderVisible = true
                    }
                case 2:
                    MessagesView().onAppear{
                        title = "Chats"
                        isHeaderVisible = true
                    }
                case 3:
                    ProfileView().onAppear{
                        title = "Profile"
                        isHeaderVisible = true
                    }
                default:
                    TestView()
                }
            }
            
        }
        
        VStack{
            NavBarView(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    CompiledMainPageView()
}
