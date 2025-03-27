//
//  HeaderView.swift
//  Mobile Development CA2
//
//  Created by Student on 20/03/2025.
//

import SwiftUI

struct HeaderView: View {
    
    @Binding var title : String
    @Binding var selectedTab: Int
    @State private var showFilterText = false
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.black)
                
                
            }
            Spacer()
            Image(systemName: "bell")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            
            if selectedTab == 0 {
                filterButton
            }
            Spacer()
            
        }
        .padding(.horizontal, 20)
    }
    private var filterButton: some View {
        Button(action: {
            showFilterText.toggle()
        }) {
            HStack {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.black)
                Text("Filters")
                    .foregroundColor(.black)
            }
            .padding(12)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(radius: 2)
        }
    }
    
}



#Preview {
    @Previewable @State var title = "Search Jobs"
    @Previewable  @State var selectedTab = 0
    
    HeaderView(title: $title, selectedTab: $selectedTab)
}
