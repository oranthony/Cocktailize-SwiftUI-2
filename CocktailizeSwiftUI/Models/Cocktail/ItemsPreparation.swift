//
//  ItemsPreparation.swift
//  Cocktailize
//
//  Created by anthony loroscio on 09/05/2019.
//  Copyright © 2019 anthony loroscio. All rights reserved.
//

import Foundation
struct ItemsPreparation : Codable {
    var index : Int?
    var words : [Words]?
    
    enum CodingKeys: String, CodingKey {
        
        case index = "index"
        case words = "words"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        index = try values.decodeIfPresent(Int.self, forKey: .index)
        words = try values.decodeIfPresent([Words].self, forKey: .words)
    }
    
    init() {
        index = 1
        words = [Words()]
    }
    
}
