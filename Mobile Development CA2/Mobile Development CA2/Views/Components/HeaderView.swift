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
    @State private var showFilterText = true
    @Binding var isVisible: Bool
    var body: some View {
        if(isVisible){

            ZStack {
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.black)
                        
                        
                    }
                    Spacer()
                    
                    HStack{
                        if selectedTab == 0 {
                            filterButton
                        }
                        
                        Image(systemName: "bell")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black).padding(12)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .shadow(radius: 2).padding(.leading,10)
                    }
                }
                .padding(.horizontal, 20)
            }.background(Color.secondaryColor).ignoresSafeArea(.container, edges: .bottom)
        }
}
private var filterButton: some View {
Button(action: {
    showFilterText.toggle()
}) {
    HStack {
        Image(systemName: "slider.horizontal.3")
            .foregroundColor(.black)
        if(false){
            Text("Filters")
                .foregroundColor(.black)
        
        }
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
    @Previewable  @State var isVisible =  true
    
    HeaderView(title: $title, selectedTab: $selectedTab,isVisible: $isVisible)
}
