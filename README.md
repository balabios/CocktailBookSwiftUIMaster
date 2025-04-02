# CocktailBookSwiftUIMaster

CocktailBookSwiftUIMaster is a SwiftUI-based iOS application designed to showcase various cocktails, their detailed descriptions, ingredients, and preparation methods. The app allows users to filter cocktails by alcoholic and non-alcoholic types and manage favorites conveniently.

## Features

- **Cocktail List**: Browse a variety of cocktails.
- **Detailed View**: Each cocktail has a detailed description, ingredients list, and preparation instructions.
- **Filtering Options**: Easily filter cocktails by categories such as alcoholic and non-alcoholic.
- **Favorites**: Mark and manage your favorite cocktails.
- **Persistent Favorites**: Favorites are saved using UserDefaults.

## Project Structure

```
CocktailBookSwiftUIMaster
│
├── Models
│   └── Cocktail.swift
├── Resources
│   └── sample.json
├── Utilities
│   └── PersistenceManager.swift
├── ViewModels
│   └── CocktailViewModel.swift
├── Views
│   ├── MainView.swift
│   └── DetailView.swift
└── CocktailBookSwiftUIMasterApp.swift
```

## Requirements

- Xcode 15 or later
- Swift 5 or later
- iOS 18.2 or later

## Installation

Clone the repository and open it in Xcode:

```bash
git clone https://github.com/balabios/CocktailBookSwiftUIMaster.git
cd CocktailBookSwiftUIMaster
open CocktailBookSwiftUIMaster.xcodeproj
```

## Running Tests

The project includes comprehensive unit tests to ensure reliability:

- Open the project in Xcode.
- Press `Cmd+U` or select `Product > Test` to run all unit tests.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any enhancements or fixes.

## License

This project is available under the MIT License.
