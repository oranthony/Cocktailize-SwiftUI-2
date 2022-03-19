//
//  CocktailViewModel.swift
//  CocktailizeSwiftUI
//
//  Created by anthony loroscio on 14/04/2020.
//  Copyright © 2020 anthony loroscio. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import UIImageColors

class CocktailViewModel: ObservableObject, Identifiable, Hashable {
    let objectWillChange = PassthroughSubject<CocktailViewModel, Never>()
    
    let id = UUID()
    var cocktailImage: UrlImageView?
    var cocktail = Items()
    var ingredients: String = ""
    
    @Published var imageLoaded = false
    
    @Published var backgroundColor = UIColor(red: 0.7882, green: 0.7882, blue: 0.7882, alpha: 1.0) {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    static func == (lhs: CocktailViewModel, rhs: CocktailViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    //TODO: deprecated, to change
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init() {
        //self.cocktailImage = ImageView(withURL: "", height: 0) {_ in }
        print("init empty")
        self.cocktailImage = UrlImageView(urlString: nil, height: 0, completionHandler: {_ in
            self.imageLoaded = true
        })
    }
    
    init(cocktail: Items) {
        self.cocktail = cocktail
        //TODO: remove height from initializer && set default image with an actual image
        
        //backgroundColor = setBackgroundColor()
        createIngredientList()
        loadPicture()
    }
    
    func createIngredientList() {
        for (_, subElement) in (cocktail.ingredients?.items?.enumerated())! {
            ingredients += "- " + (subElement.ingredient ?? "").capitalizedFirst() + "\n"
        }
    }
    
    func loadPicture() {
        // Set the cocktail image
        self.cocktailImage = UrlImageView(urlString: cocktail.imageUrl, height: UIScreen.main.bounds.size.height * 0.55, completionHandler: {result in
            self.imageLoaded = true
            if (result != nil) {
                self.backgroundColor = result!
            } else {
                self.setBackgroundColor(image: self.cocktailImage?.urlImageModel.image ?? UIImage(imageLiteralResourceName: "Image"))
            }
        })
    }
    
    /**
     Compute the ideal background color for the cocktail card from the cocktail image
     */
    func setBackgroundColor(image: UIImage)  {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        var color = UIColor()
        
        // Compute the background color from the cocktail image on the background
        DispatchQueue.global(qos: .userInitiated).async {
            image.getColors()!.background.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            color = UIColor(hue: hue, saturation: 0.28, brightness: 1, alpha: 1)
            // Update the UI from the main thread
            DispatchQueue.main.async {
                self.backgroundColor = color
            }
            return
        }
    }
    
}

// Capitalize letters
extension String {
    func capitalizedFirst() -> String {
        let first = self[self.startIndex ..< self.index(startIndex, offsetBy: 1)]
        let rest = self[self.index(startIndex, offsetBy: 1) ..< self.endIndex]
        return first.uppercased() + rest.lowercased()
    }
    
    func capitalizedFirst(with: Locale?) -> String {
        let first = self[self.startIndex ..< self.index(startIndex, offsetBy: 1)]
        let rest = self[self.index(startIndex, offsetBy: 1) ..< self.endIndex]
        return first.uppercased(with: with) + rest.lowercased(with: with)
    }
}
