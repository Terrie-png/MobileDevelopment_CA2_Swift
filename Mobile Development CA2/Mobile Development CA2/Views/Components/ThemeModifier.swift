//
//  ThemeModifier.swift
//  Mobile Development CA2
//
//  Created by Student on 03/04/2025.
//

import SwiftUI

struct ThemeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
             // Applies to all buttons, etc.
            .background(Color.secondaryColor)
    }
}

extension View {
    func applyTheme() -> some View {
        modifier(ThemeModifier())
    }
}

