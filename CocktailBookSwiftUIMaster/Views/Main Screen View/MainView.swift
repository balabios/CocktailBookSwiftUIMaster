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
                filterPicker
                contentView
            }
            .navigationTitle(viewModel.filterType.rawValue)
        }
    }
    
    // MARK: - Subviews
    
    private var filterPicker: some View {
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
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.cocktails.isEmpty && viewModel.errorMessage == nil {
            loadingView
        } else if let errorMessage = viewModel.errorMessage {
            errorView(message: errorMessage)
        } else {
            cocktailsListView
        }
    }
    
    private var loadingView: some View {
        ProgressView("Loading Cocktails...")
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    private func errorView(message: String) -> some View {
        Text(message)
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    private var cocktailsListView: some View {
        List(viewModel.filteredCocktails) { cocktail in
            NavigationLink(destination: DetailView(
                cocktail: cocktail,
                viewModel: viewModel,
                backText: viewModel.filterType.rawValue
            )) {
                CocktailRow(
                    cocktail: cocktail,
                    isFavorite: viewModel.favoriteCocktails.contains(cocktail.id)
                )
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct CocktailRow: View {
    let cocktail: Cocktail
    let isFavorite: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(cocktail.name)
                    .font(.headline)
                    .foregroundColor(isFavorite ? .purple : .primary)
                Text(cocktail.shortDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundColor(.purple)
            }
        }
    }
}
