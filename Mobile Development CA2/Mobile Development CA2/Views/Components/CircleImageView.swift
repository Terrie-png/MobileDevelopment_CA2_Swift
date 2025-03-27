//
//  CircleImageView.swift
//  Mobile Development CA2
//
//  Created by Student on 27/03/2025.
//

import SwiftUI

struct CircleImageView: View {
    var body: some View {
        Image("Turtle")
            .resizable()  // Make the image resizable
                    .scaledToFit()  // Ensures the image fits inside the circle without cropping
                    .clipShape(Circle())  // Clips the image into a circle shape
                    .overlay {
                        Circle().stroke(.gray, lineWidth: 4)  // Adds a border around the circle
                    }
                    .shadow(radius: 7)
           }
    }


#Preview {
    CircleImageView()
}
