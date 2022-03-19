//
//  FavoritesCocktailsViewModel.swift
//  CocktailizeSwiftUI
//
//  Created by anthony loroscio on 28/04/2020.
//  Copyright © 2020 anthony loroscio. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class FavoritesCocktailsViewModel: ObservableObject {
    let objectWillChange = PassthroughSubject<FavoritesCocktailsViewModel, Never>()
    
    //@Published var isCocktailListEmpty = true
    //@Published var favoriteCocktails: Json4Swift_Base?
    
    init() {
        // Retreive stored favorites
        /*let defaults = UserDefaults.standard
        if let savedCocktails = defaults.object(forKey: "favoriteCocktailArray") as? Data {
            let decoder = JSONDecoder()
            if let loadedCocktails = try? decoder.decode(Json4Swift_Base.self, from: savedCocktails) {
                favoriteCocktails = loadedCocktails
                if (favoriteCocktails?.items?.count == 0) {
                    isCocktailListEmpty = true
                    print("favorite empty")
                } else {
                    isCocktailListEmpty = false
                    print("favorite present")
                }
            } else {
                isCocktailListEmpty = true
            }
        } else {
            isCocktailListEmpty = true
        }*/
        
    }
    
}
