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
    var body : some View{
        HeaderView(title: $title)
        ZStack{
            switch selectedTab {
            case 0:
                
                CardStackView().onAppear{
                    title = "Search Jobs"
                }
                
            case 1:
                AppliedJobsView().onAppear{
                    title = "Jobs Applied"
                }
            case 2:
                MessagesView().onAppear{
                    title = "Chats"
                }
            case 3:
                ProfileView().onAppear{
                    title = "Profile"
                }
            default:
                TestView()
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
