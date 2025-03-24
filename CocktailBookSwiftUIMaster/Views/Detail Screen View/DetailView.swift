//
//  DetailView.swift
//  CocktailBookSwiftUIMaster
//
//  Created by Bollisetty Bala Baskar on 23/03/25.
//


import SwiftUI

struct DetailView: View {
    let cocktail: Cocktail
    @ObservedObject var viewModel: CocktailViewModel
    let backText: String
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                headerView
                cocktailImageView
                descriptionView
                ingredientsListView
            }
            .navigationTitle(cocktail.name)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    favoriteButton
                }
            }
        }
    }

    // MARK: - Subviews
    private var headerView: some View {
        HStack {
            Image(systemName: "clock")
            Text("\(cocktail.preparationMinutes) Minutes")
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding([.leading, .trailing])
    }

    private var cocktailImageView: some View {
        HStack {
            Spacer()
            Image(cocktail.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
                .padding()
        }
    }

    private var descriptionView: some View {
        Text(cocktail.longDescription)
            .font(.body)
            .padding()
    }

    private var ingredientsListView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ingredients")
                .font(.headline)
            ForEach(cocktail.ingredients, id: \.self) { ingredient in
                ingredientRow(for: ingredient)
            }
        }
        .padding()
    }

    private func ingredientRow(for ingredient: String) -> some View {
        HStack {
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 8, height: 8)
            Text(ingredient)
        }
    }

    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.red)
                Text(backText)
                    .foregroundColor(.red)
            }
        }
    }

    private var favoriteButton: some View {
        Button(action: {
            viewModel.toggleFavorite(for: cocktail)
        }) {
            Image(systemName: viewModel.favoriteCocktails.contains(cocktail.id) ? "heart.fill" : "heart")
                .foregroundColor(viewModel.favoriteCocktails.contains(cocktail.id) ? .purple : .gray)
        }
    }
}
