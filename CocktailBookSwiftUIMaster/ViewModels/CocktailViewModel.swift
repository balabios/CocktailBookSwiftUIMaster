//
//  CocktailViewModel.swift
//  CocktailBookSwiftUIMaster
//
//  Created by Bollisetty Bala Baskar on 23/03/25.
//

import Foundation
import Combine
import CocktailsAPIStaticLib

class CocktailViewModel: ObservableObject {
    @Published var cocktails: [Cocktail] = []
    @Published var filteredCocktails: [Cocktail] = []
    @Published var favoriteCocktails: Set<String> = []
    @Published var filterType: FilterType = .all
    @Published var errorMessage: String?

    private let api: CocktailsAPI
    private let persistenceManager = PersistenceManager.shared
    private var cancellables = Set<AnyCancellable>()

    init(api: CocktailsAPI = FakeCocktailsAPI()) {
        self.api = api
        self.favoriteCocktails = persistenceManager.loadFavorites()
        fetchCocktails()
    }

    enum FilterType: String {
        case all = "All Cocktails"
        case alcoholic = "Alcoholic"
        case nonAlcoholic = "Non-Alcoholic"
    }

    func fetchCocktails() {
        api.cocktailsPublisher
            .decode(type: [Cocktail].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    self?.errorMessage = "Failed to load cocktails. Please try again."
                }
            }, receiveValue: { [weak self] cocktails in
                self?.errorMessage = nil
                self?.cocktails = cocktails
                self?.updateFilteredCocktails()
            })
            .store(in: &cancellables)
    }

    func updateFilteredCocktails() {
        switch filterType {
        case .all:
            filteredCocktails = cocktails
        case .alcoholic:
            filteredCocktails = cocktails.filter { $0.type.lowercased() == "alcoholic" }
        case .nonAlcoholic:
            filteredCocktails = cocktails.filter { $0.type.lowercased() == "non-alcoholic" }
        }
        sortCocktails()
    }

    func toggleFavorite(for cocktail: Cocktail) {
        if favoriteCocktails.contains(cocktail.id) {
            favoriteCocktails.remove(cocktail.id)
        } else {
            favoriteCocktails.insert(cocktail.id)
        }
        persistenceManager.saveFavorites(favoriteCocktails)
        updateFilteredCocktails()
    }
    
    private func sortCocktails() {
        filteredCocktails.sort {
            let isFavorite1 = favoriteCocktails.contains($0.id)
            let isFavorite2 = favoriteCocktails.contains($1.id)
            if isFavorite1 != isFavorite2 {
                return isFavorite1
            }
            return $0.name < $1.name
        }
    }
}
