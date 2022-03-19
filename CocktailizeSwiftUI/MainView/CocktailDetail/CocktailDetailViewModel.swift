//
//  CocktailDetailViewModel.swift
//  CocktailizeSwiftUI
//
//  Created by anthony loroscio on 23/04/2020.
//  Copyright © 2020 anthony loroscio. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class CocktailDetailViewModel: ObservableObject, Identifiable {
    let objectWillChange = PassthroughSubject<CocktailDetailViewModel, Never>()
    let id = UUID()
    
    var cocktail = Items()
    var cocktailImage: UrlImageView?
    var ingredients: String = ""
    var stepsList: [String] = []
    var backgroundColor = UIColor(red: 0.7882, green: 0.7882, blue: 0.7882, alpha: 1.0)
    
    @Published var favoriteCocktails: Json4Swift_Base?
    @Published var imageLoaded = false {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send(self)
            }
        }
    }
    @Published var isCocktailFavorite = false {
        didSet {
            objectWillChange.send(self)
        }
    }

    
    init(cocktail: Items, backgroundColor: UIColor) {
        self.cocktail = cocktail
        self.backgroundColor = backgroundColor
        
        loadPicture()
        createIngredientList()
        createStepsList()
        loadFavoritesFromStorage()
    }
    
    private func loadPicture() {
        self.cocktailImage = UrlImageView(urlString: cocktail.imageUrl, height: UIScreen.main.bounds.size.height * 0.52, completionHandler: {_ in
            self.imageLoaded = true
        })
    }
    
    private func createIngredientList() {
        for (_, subElement) in (cocktail.ingredients?.items?.enumerated())! {
            ingredients += (subElement.quantity ?? "") + " " + (subElement.ingredient ?? "") + "\n"
        }
    }
    
    private func createStepsList() {
        for (position, element) in cocktail.preparationSteps!.items!.enumerated() {
            if (element.index == position + 1) {
                if let words = element.words {
                    var currentLine = ""
                    var previousWord = ""
                    for (_, subElement) in words.enumerated() {
                        currentLine.append(subElement.word ?? "")
                        if (previousWord != "" && subElement.word == ",") {
                            currentLine.append(" ")
                        }
                        previousWord = subElement.word ?? ""
                    }
                    currentLine = currentLine.capitalizedFirst()
                    stepsList.append(currentLine)
                }
            }
        }
    }
    
    private func loadFavoritesFromStorage() {
        // Retreive the favorites cocktails from storage
        let defaults = UserDefaults.standard
        if let savedCocktails = defaults.object(forKey: "favoriteCocktailArray") as? Data {
            let decoder = JSONDecoder()
            if let loadedCocktails = try? decoder.decode(Json4Swift_Base.self, from: savedCocktails) {
                self.favoriteCocktails = loadedCocktails
            }
        }
        
        // Check if current cocktail is stored in favorite
        if (self.favoriteCocktails != nil) {
            if ((self.favoriteCocktails!.getCocktailByName(name: self.cocktail.name ?? "")) != nil) {
                //favoriteButton.setImage(redFavoriteIcon, for: .normal)
                self.isCocktailFavorite = true
                print("current cocktail is favorite")
            }
        } else {
            self.isCocktailFavorite = false
            print("current cocktail is not favorite")
        }
    }
    
    /**
    Store given cocktail to favorites in userDefaults
     */
    func addCocktailToFavorites() {
        print("adding cocktail")
        
        let userdefaults = UserDefaults.standard
        let encoder = JSONEncoder()
        
        // If the cocktail is already in the facorite  list then we have to remove it
        if (self.favoriteCocktails != nil && self.isCocktailFavorite) {
            // Remove this cocktail from the favorite cocktail list
            if let cocktailIndex = self.favoriteCocktails!.findCocktail(cocktail: cocktail) {
                self.favoriteCocktails?.items?.remove(at: cocktailIndex)
            }
            
            // Store this new list of favorites cocktails to storage
            if let encoded = try? encoder.encode(self.favoriteCocktails) {
                userdefaults.set(encoded, forKey: "favoriteCocktailArray")
            }
            
            // Change the color of the icon of the favorite button
            //let greyFavoriteIcon = UIImage(named: "Image-4")!
            //favoriteButton.setImage(greyFavoriteIcon, for: .normal)
            self.isCocktailFavorite = false
            
            // We also remove it from userData environment object
            
        }
        // Otherwise the cocktail is not in the favorite list so we ha to add it
        else {
            // If the user has already liked some cocktails we already have a struct stored so we just retreive it and
            //modify it
            if (isKeyPresentInUserDefaults(key: "favoriteCocktailArray")) {
                //
                favoriteCocktails?.items?.append(cocktail)
                if let encoded = try? encoder.encode(self.favoriteCocktails) {
                    userdefaults.set(encoded, forKey: "favoriteCocktailArray")
                }
            }
            // If the user has never liked any cocktails we need to create an empty cocktailList struct and then store it
            else {
                var newArray = Json4Swift_Base()
                newArray.items = [cocktail]
                
                if let encoded = try? encoder.encode(newArray) {
                    userdefaults.set(encoded, forKey: "favoriteCocktailArray")
                }
            }
            self.isCocktailFavorite = true
        }

    }
    
    private func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
