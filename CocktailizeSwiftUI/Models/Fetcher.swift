//
//  Fetcher.swift
//  CocktailizeSwiftUI
//
//  Created by anthony loroscio on 12/04/2020.
//  Copyright © 2020 anthony loroscio. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

public class CocktailFetcher: ObservableObject {
    //@EnvironmentObject var userData: UserData
    @Published var results = Json4Swift_Base()
    @State var isCalling = false
    
    // TO DO: Remvoe Singleton
    //static let sharedInstance = CocktailFetcher()
    
    init(){
        //load()
    }
    
    func load() {
        if (!isCalling) {
            print("start calling")
            isCalling = true
            let url = URL(string: "https://cocktailflow.com/ajax/search/more/cocktail?count=40&phrase=vodka")!
            
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                print("call online")
               
                    if let decodedResponse = try? JSONDecoder().decode(Json4Swift_Base.self, from: data!) {
                        DispatchQueue.main.async {
                            print(decodedResponse)
                            self.results = decodedResponse
                            self.isCalling = false
                            //self.userData.cocktailList = decodedResponse
                            print("stop calling")
                        }
                        return
                    }
                
            }
            task.resume()
        }
             
    }
    
    
    
}
