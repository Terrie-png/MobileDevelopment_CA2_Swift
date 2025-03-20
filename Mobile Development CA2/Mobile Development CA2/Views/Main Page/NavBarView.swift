//
//  NavBarView.swift
//  Mobile Development CA2
//
//  Created by Student on 20/03/2025.
//

import SwiftUI

struct NavBarView: View {
    var body: some View {
        ZStack {
            // Background shape
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.quaternary) // Adjust color as needed
                .frame(height: 80)
                .padding(.horizontal, 20)
                .shadow(radius: 5)

            HStack(spacing: 40) {
                Button(action: {
                    // Action for first button
                }) {
                    Image(systemName: "briefcase.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                }
                
                ZStack {
                    Capsule()
                        .fill(Color.secondaryColor)
                        .frame(width: 100, height: 45)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.backgroundColor)
                        Text("Search")
                            .foregroundColor(Color.backgroundColor)
                            .font(.system(size: 16, weight: .bold))
                    }
                }
                
                Button(action: {
                    // Action for second button
                }) {
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                }
                
                Button(action: {
                    // Action for third button
                }) {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                }
            }
            .padding(.bottom, 10)
        }
    }
}

#Preview {
    NavBarView()
}

