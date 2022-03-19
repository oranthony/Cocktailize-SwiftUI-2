//
//  HomeViewModel.swift
//  CocktailizeSwiftUI
//
//  Created by anthony loroscio on 30/04/2020.
//  Copyright © 2020 anthony loroscio. All rights reserved.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    init() {
        
    }
    
    func loadFavoritesCocktails() -> Json4Swift_Base {
        let defaults = UserDefaults.standard
        if let savedCocktails = defaults.object(forKey: "favoriteCocktailArray") as? Data {
            let decoder = JSONDecoder()
            if let loadedCocktails = try? decoder.decode(Json4Swift_Base.self, from: savedCocktails) {
                return loadedCocktails as Json4Swift_Base
            }
        }
        return Json4Swift_Base()
    }
}
