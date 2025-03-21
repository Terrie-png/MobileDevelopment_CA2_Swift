//
//  HeaderView.swift
//  Mobile Development CA2
//
//  Created by Student on 20/03/2025.
//

import SwiftUI

struct HeaderView: View {
    
    @Binding var title
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Search")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.black)

                Text("Jobs")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.black.opacity(0.8))
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
#Preview {
    HeaderView()
}
