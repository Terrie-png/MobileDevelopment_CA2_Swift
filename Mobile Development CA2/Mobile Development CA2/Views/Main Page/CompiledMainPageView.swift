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
    @State private var selectedJobTypes: Set<String> = []
    @State private var selectedLocations: Set<String> = []
    @State private var selectedSeniorities: Set<String> = []
    @State private var selectedJobTitles: Set<String> = []
    
 
    
    @Binding var isLoggedIn: Bool
    var body : some View{
        ZStack{
            
            Color.secondaryColor.ignoresSafeArea()
            VStack{
                HeaderView(title: $title,selectedTab: $selectedTab, isVisible: $isVisible,
                           selectedJobTypes: $selectedJobTypes,
                           selectedLocations: $selectedLocations,
                           selectedSeniorities: $selectedSeniorities,
                           selectedJobTitles: $selectedJobTitles
                           )
                
                NavigationStack{
                    ZStack{
                        switch selectedTab {
                        case 0:
                            
                            CardStackView( selectedJobTypes: $selectedJobTypes,
                                           selectedLocations: $selectedLocations,
                                           selectedSeniorities: $selectedSeniorities,
                                           selectedJobTitles: $selectedJobTitles
                                
                            ).onAppear{
                                title = "Search Jobs"
                                isVisible = true
                                
                                
                            }
                            
                        case 1:
                            AppliedJobsView(isVisible: $isVisible).onAppear{
                                title = "Jobs Hiring People"
                                isVisible = true
                            }
                        case 2:
                            ChatView(
                                
                            
                                     isVisible: $isVisible).onAppear{
                                title = "Chats"
                                isVisible = true
                            }
                        case 3:
                            ProfileView(isVisible: $isVisible, isLoggedIn: $isLoggedIn).onAppear{
                                title = "Profile"
                                isVisible = true
                            }
                        default:
                            CardStackView(selectedJobTypes: $selectedJobTypes,
                                          selectedLocations: $selectedLocations,
                                          selectedSeniorities: $selectedSeniorities,
                                          selectedJobTitles: $selectedJobTitles).onAppear{
                                title = "Search Jobs"
                                isVisible = true
                            }
                            Spacer()
                        }
                    }
                    
                    
                    
                }
                NavBarView(selectedTab: $selectedTab, isVisible: $isVisible).padding(.bottom)
            }
        }
    }
    
}
