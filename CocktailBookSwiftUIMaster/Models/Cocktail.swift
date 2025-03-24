//
//  Cocktail.swift
//  CocktailBookSwiftUIMaster
//
//  Created by Bollisetty Bala Baskar on 23/03/25.
//


import Foundation

struct Cocktail: Identifiable, Decodable {
    let id: String
    let name: String
    let type: String
    let shortDescription: String
    let longDescription: String
    let preparationMinutes: Int
    let imageName: String
    let ingredients: [String]
}
