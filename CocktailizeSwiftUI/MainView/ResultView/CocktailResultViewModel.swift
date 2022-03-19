//
//  CocktailResultViewModel.swift
//  CocktailizeSwiftUI
//
//  Created by anthony loroscio on 14/04/2020.
//  Copyright © 2020 anthony loroscio. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class CocktailResultViewModel: ObservableObject {
    var items: [Items]
    
    init() {
        print("enter empty init")
        self.items = [Items()]
    }
    
    init(items: [Items]) {
        self.items = items
    }
   
}


