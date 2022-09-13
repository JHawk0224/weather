//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Jordan H on 9/2/22.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.red]
    }
    
    var body: some Scene {
        WindowGroup {
            WeatherView()
        }
    }
}
