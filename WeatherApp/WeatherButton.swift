//
//  WeatherButton.swift
//  WeatherApp
//
//  Created by Jordan H on 9/2/22.
//

import SwiftUI
struct WeatherButton: View {
    var text: String
    var textColor: Color
    var backgroundColor: Color
    
    var body: some View {
        Text(text)
            .frame(width: 280, height: 50)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .font(.system(size: 20, weight: .semibold, design: .default))
            .cornerRadius(15.0)
    }
}
