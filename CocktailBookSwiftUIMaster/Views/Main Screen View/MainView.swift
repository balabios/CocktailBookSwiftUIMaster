//
//  MainView.swift
//  CocktailBookSwiftUIMaster
//
//  Created by Bollisetty Bala Baskar on 23/03/25.
//


import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = CocktailViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Filter", selection: $viewModel.filterType) {
                    Text("All").tag(CocktailViewModel.FilterType.all)
                    Text("Alcoholic").tag(CocktailViewModel.FilterType.alcoholic)
                    Text("Non-Alcoholic").tag(CocktailViewModel.FilterType.nonAlcoholic)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: viewModel.filterType) { newFilterType, _ in
                    viewModel.updateFilteredCocktails()
                }
                
                if viewModel.cocktails.isEmpty && viewModel.errorMessage == nil {
                    // Show a ProgressView while loading
                    ProgressView("Loading Cocktails...")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    // Show the error message if there is one
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List(viewModel.filteredCocktails) { cocktail in
                        NavigationLink(destination: DetailView(cocktail: cocktail, viewModel: viewModel)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(cocktail.name)
                                        .font(.headline)
                                        .foregroundColor(viewModel.favoriteCocktails.contains(cocktail.id) ? .purple : .primary)
                                    Text(cocktail.shortDescription)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                if viewModel.favoriteCocktails.contains(cocktail.id) {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.purple)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle(viewModel.filterType.rawValue)
        }
    }
}
