//
//  PersistenceManager.swift
//  CocktailBookSwiftUIMaster
//
//  Created by Bollisetty Bala Baskar on 23/03/25.
//



import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()

    private let favoritesKey = "favorites"

    func saveFavorites(_ favorites: Set<String>) {
        UserDefaults.standard.set(Array(favorites), forKey: favoritesKey)
    }

    func loadFavorites() -> Set<String> {
        let favorites = UserDefaults.standard.array(forKey: favoritesKey) as? [String] ?? []
        return Set(favorites)
    }
}
