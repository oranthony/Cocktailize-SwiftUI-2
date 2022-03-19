//
//  Cocktail.swift
//  CocktailizeSwiftUI
//
//  Created by anthony loroscio on 12/04/2020.
//  Copyright © 2020 anthony loroscio. All rights reserved.
//

import Foundation

struct Cocktail: Decodable, Identifiable {
    var id: String
    public var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "key"
        case name = "name"
    }
}
