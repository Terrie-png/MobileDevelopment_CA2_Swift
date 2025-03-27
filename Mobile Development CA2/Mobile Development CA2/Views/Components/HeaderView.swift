//
//  HeaderView.swift
//  Mobile Development CA2
//
//  Created by Student on 20/03/2025.
//

import SwiftUI

struct HeaderView: View {

    @Binding var title : String
    @Binding var isVisible: Bool
    var body: some View {
        if(isVisible){
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.black)
                    
                }
                
                Spacer()
                
                Button(action: {
                    print("Filter button tapped")
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
            .padding(.horizontal, 20)
        }
    }
}
