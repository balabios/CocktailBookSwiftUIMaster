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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image(cocktail.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()

                Text(cocktail.longDescription)
                    .font(.body)
                    .padding()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Ingredients")
                        .font(.headline)
                    ForEach(cocktail.ingredients, id: \.self) { ingredient in
                        HStack {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 8, height: 8)
                            Text(ingredient)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(cocktail.name)
            .toolbar {
                Button(action: {
                    viewModel.toggleFavorite(for: cocktail)
                }) {
                    Image(systemName: viewModel.favoriteCocktails.contains(cocktail.id) ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.favoriteCocktails.contains(cocktail.id) ? .purple : .gray)
                }
            }
        }
    }
}
