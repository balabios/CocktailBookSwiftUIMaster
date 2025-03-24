//
//  PersistenceManager.swift
//  CocktailBookSwiftUIMaster
//
//  Created by Bollisetty Bala Baskar on 23/03/25.
//



import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    private init() {}
    
    private let favoritesKey = "favorites"
    private let defaults = UserDefaults.standard
    
    func saveFavorites(_ favorites: Set<String>) {
        defaults.set(Array(favorites), forKey: favoritesKey)
    }

    func loadFavorites() -> Set<String> {
        let favorites = defaults.array(forKey: favoritesKey) as? [String] ?? []
        return Set(favorites)
    }
}
