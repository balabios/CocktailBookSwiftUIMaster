//
//  CocktailBookSwiftUIMasterTests.swift
//  CocktailBookSwiftUIMaster
//
//  Created by Bollisetty Bala Baskar on 23/03/25.
//

import XCTest
import Combine
import CocktailsAPIStaticLib

@testable import CocktailBookSwiftUIMaster

class CocktailBookSwiftUIMasterTests: XCTestCase {
    var viewModel: CocktailViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = CocktailViewModel(api: FakeCocktailsAPI())
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    // ✅ Test: Fetch Cocktails Successfully
    func testFetchingCocktails() {
        let expectation = XCTestExpectation(description: "Cocktails should be fetched successfully")

        viewModel.$cocktails
            .dropFirst()
            .sink { cocktails in
                XCTAssertGreaterThan(cocktails.count, 0, "Cocktail list should not be empty")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchCocktails()
        wait(for: [expectation], timeout: 5.0)
    }
    
    // ✅ Test: Fetch Cocktails Failure - Ensures errorMessage is set and no cocktails are loaded
    func testFetchCocktailsFailureAndNoCocktailsLoaded() {
        viewModel = CocktailViewModel(api: FakeCocktailsAPI(withFailure: .count(1)))
        let expectation = XCTestExpectation(description: "Handle API failure and verify cocktails array is empty")

        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertNotNil(errorMessage, "Error message should not be nil when API fails")
                XCTAssertEqual(errorMessage, "Failed to load cocktails. Please try again.", "Error message does not match expected output")
                
                // Verify that the cocktails array is empty
                XCTAssertTrue(self.viewModel.cocktails.isEmpty, "Cocktail array should be empty when API fails")
                
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchCocktails()
        wait(for: [expectation], timeout: 15.0)
    }

    // ✅ Test: Filtering All Cocktails
    func testFilteringAllCocktails() {
        viewModel.filterType = .all
        viewModel.updateFilteredCocktails()

        XCTAssertEqual(viewModel.filteredCocktails.count, viewModel.cocktails.count, "Filtered list should match full cocktail list")
    }

    // ✅ Test: Filtering Alcoholic Cocktails
    func testFilteringAlcoholicCocktails() {
        viewModel.filterType = .alcoholic
        viewModel.updateFilteredCocktails()

        for cocktail in viewModel.filteredCocktails {
            XCTAssertEqual(cocktail.type.lowercased(), "alcoholic", "Filtered cocktails should be alcoholic")
        }
    }

    // ✅ Test: Filtering Non-Alcoholic Cocktails
    func testFilteringNonAlcoholicCocktails() {
        viewModel.filterType = .nonAlcoholic
        viewModel.updateFilteredCocktails()

        for cocktail in viewModel.filteredCocktails {
            XCTAssertEqual(cocktail.type.lowercased(), "non-alcoholic", "Filtered cocktails should be non-alcoholic")
        }
    }

    // ✅ Test: Toggling Favorite Status
    func testTogglingFavorite() {
        let testCocktail = Cocktail(
            id: "1",
            name: "Mojito",
            type: "Alcoholic",
            shortDescription: "Refreshing cocktail",
            longDescription: "A classic mojito cocktail with fresh mint and lime.",
            preparationMinutes: 5,
            imageName: "mojito",
            ingredients: ["Rum", "Mint", "Lime"]
        )

        viewModel.toggleFavorite(for: testCocktail)
        XCTAssertTrue(viewModel.favoriteCocktails.contains(testCocktail.id), "Cocktail should be marked as favorite")

        viewModel.toggleFavorite(for: testCocktail)
        XCTAssertFalse(viewModel.favoriteCocktails.contains(testCocktail.id), "Cocktail should be removed from favorites")
    }

    // ✅ Test: Persistence of Favorites in UserDefaults
    func testPersistenceOfFavorites() {
        let testCocktail = Cocktail(
            id: "2",
            name: "Virgin Mojito",
            type: "Non-Alcoholic",
            shortDescription: "Refreshing mocktail",
            longDescription: "A non-alcoholic mojito for everyone to enjoy.",
            preparationMinutes: 5,
            imageName: "virgin_mojito",
            ingredients: ["Mint", "Lime", "Soda"]
        )

        viewModel.toggleFavorite(for: testCocktail)
        let savedFavorites = PersistenceManager.shared.loadFavorites()

        XCTAssertTrue(savedFavorites.contains(testCocktail.id), "Cocktail should be saved in persistence")

        viewModel.toggleFavorite(for: testCocktail)
        let updatedFavorites = PersistenceManager.shared.loadFavorites()

        XCTAssertFalse(updatedFavorites.contains(testCocktail.id), "Cocktail should be removed from persistence")
    }

    // ✅ Test: Sorting Cocktails (Favorites First)
    func testSortingFavoritesFirst() {
        let cocktail1 = Cocktail(id: "1", name: "Whiskey Sour", type: "Alcoholic", shortDescription: "", longDescription: "", preparationMinutes: 5, imageName: "", ingredients: [])
        let cocktail2 = Cocktail(id: "2", name: "Virgin Mojito", type: "Non-Alcoholic", shortDescription: "", longDescription: "", preparationMinutes: 5, imageName: "", ingredients: [])

        viewModel.cocktails = [cocktail1, cocktail2]
        viewModel.toggleFavorite(for: cocktail2) // Mark cocktail2 as favorite

        viewModel.updateFilteredCocktails()

        XCTAssertEqual(viewModel.filteredCocktails.first?.id, "2", "Favorite cocktails should appear first")
    }

    // ✅ Test: Ensuring Empty List When No Data Available
    func testEmptyCocktailList() {
        viewModel.cocktails = []
        viewModel.updateFilteredCocktails()
        XCTAssertEqual(viewModel.filteredCocktails.count, 0, "Filtered cocktails should be empty when no data available")
    }
}
