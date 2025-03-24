//
//  CocktailBookSwiftUIMasterApp.swift
//  CocktailBookSwiftUIMaster
//
//  Created by Bollisetty Bala Baskar on 23/03/25.
//

import SwiftUI

@main
struct CocktailBookSwiftUIMasterApp: App {
    
    @StateObject private var viewModel = CocktailViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView() // Set MainView as the starting view
                .environmentObject(viewModel) // Inject the ViewModel into the environment
        }
    }
}
