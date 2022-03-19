//
//  CocktailDetailView.swift
//  CocktailizeSwiftUI
//
//  Created by anthony loroscio on 23/04/2020.
//  Copyright © 2020 anthony loroscio. All rights reserved.
//

import SwiftUI

/**
 CocktailDetailView display detailed information about the cocktail.
 */
struct CocktailDetailView: View {
    @EnvironmentObject var userData: UserData
    @Binding var showModal: Bool
    @ObservedObject var model: CocktailDetailViewModel
    
    let fontColor = Color(red:0.44, green: 0.44, blue: 0.44, opacity: 1.0)
    
    func addCocktailToFavorites() {
        self.model.addCocktailToFavorites()
        if ((userData.favoritesCocktails.findCocktail(cocktail: model.cocktail)) != nil)  {
                userData.favoritesCocktails.items?.remove(at: (userData.favoritesCocktails.items?.firstIndex(of: model.cocktail))!)
            } else {
                userData.favoritesCocktails.items?.append(model.cocktail)
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack() {
                VStack(alignment: .leading) {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Image("Close")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 24)
                            .onTapGesture {
                                self.showModal.toggle()
                            }
                        
                        ZStack(alignment: Alignment.leading) {
                            Text("")
                                .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.32, alignment: .leading)
                            
                            Text(self.model.cocktail.name ?? "")
                                .font(.largeTitle)
                                .foregroundColor(self.fontColor)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: geo.size.width * 0.49, maxHeight: geo.size.height * 0.32, alignment: .leading)
                        }
                        
                        Image(systemName: self.model.isCocktailFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 30.0))
                            .foregroundColor(Color.pink)
                            .frame(width: 40, alignment: .center)
                            .padding(.bottom)
                            .onTapGesture {
                                self.addCocktailToFavorites()
                            }
                    }
                    .padding([.top, .leading])
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading) {
                            Text("Ingredients")
                                .font(.largeTitle)
                                .fontWeight(.regular)
                                .foregroundColor(self.fontColor)
                                .padding(.top, 20)
                            
                            Text(self.model.ingredients)
                                .fontWeight(.light)
                                .multilineTextAlignment(.leading)
                                .lineSpacing(5)
                                .padding([.top], 10)
                                .foregroundColor(self.fontColor)
                                .font(.system(size: 20))
                            
                            Text("Preparation Steps")
                                .font(.largeTitle)
                                .fontWeight(.regular)
                                .foregroundColor(self.fontColor)
                                .multilineTextAlignment(.leading)
                            
                            ForEach(self.model.stepsList, id: \.self) {line in
                                Text(line)
                                    .fontWeight(.light)
                                    .multilineTextAlignment(.leading)
                                    .padding([.top], 10)
                                    .foregroundColor(self.fontColor)
                                    .font(.system(size: 20))
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.bottom, 40)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .background(Color(self.model.backgroundColor))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                
                if (self.model.imageLoaded) {
                    self.model.cocktailImage
                        .position(x: geo.size.width * 0.75, y: geo.size.height * 0.18)
                } else {
                    CocktailPath()
                        .position(x: geo.size.width * 0.75, y: 0)
                        .frame(height: UIScreen.main.bounds.size.height * 0.5)
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct CocktailDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CocktailDetailView(showModal: .constant(true), model: CocktailDetailViewModel(cocktail: Items(), backgroundColor: UIColor.gray))
    }
}
