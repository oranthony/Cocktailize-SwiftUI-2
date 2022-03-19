//
//  ItemsIngredient.swift
//  Cocktailize
//
//  Created by anthony loroscio on 09/05/2019.
//  Copyright © 2019 anthony loroscio. All rights reserved.
//

import Foundation
struct ItemsIngredient : Codable {
    var ingredient : String?
    var quantity : String?
    
    enum CodingKeys: String, CodingKey {
        
        case ingredient = "ingredient"
        case quantity = "quantity"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ingredient = try values.decodeIfPresent(String.self, forKey: .ingredient)
        quantity = try values.decodeIfPresent(String.self, forKey: .quantity)
    }
    
    init() {
        ingredient = "a"
        quantity = "a"
    }

}
