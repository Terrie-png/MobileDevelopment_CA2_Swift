//
//  CompiledMainPageView.swift
//  Mobile Development CA2
//
//  Created by Student on 20/03/2025.
//

import SwiftUI

struct CompiledMainPageView: View {
    var body: some View {
        NavigationStack{
            VStack {
                HeaderView()
                CardStackView()
                NavBarView()
            }
        }
       
    }
}

#Preview {
    CompiledMainPageView()
}
