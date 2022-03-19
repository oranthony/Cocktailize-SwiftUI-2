//
//  IngredientRow.swift
//  CocktailizeSwiftUI
//
//  Created by anthony loroscio on 04/04/2020.
//  Copyright © 2020 anthony loroscio. All rights reserved.
//

import SwiftUI

struct SelectedIngredientsRow: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        IngredientRow(items: userData.selectedIngredients, isRecentIngredientType: false)
    }
}

struct RecentIngredientRow: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        IngredientRow(items: userData.recentIngredients, isRecentIngredientType: true)
    }
}

struct IngredientRow: View {
    var items: [String]
    let fontColor = Color(red:0.44, green: 0.44, blue: 0.44, opacity: 1.0)
    var isRecentIngredientType: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items, id: \.self) { ingredient in
                        CategoryItem(isRecentIngredientType: self.isRecentIngredientType, ingredient: ingredient).transition(.move(edge: .leading))
                        .padding(.leading, 33)
                    }
                }
            }
            .frame(height: 112)
        }
    }
}

struct CategoryItem: View {
    @EnvironmentObject var userData: UserData
    var isRecentIngredientType: Bool
    var ingredient: String
    
    var body: some View {
        VStack {
            Text(ingredient)
                .font(.system(size: 22))
                .fontWeight(.light)
                .foregroundColor(Color(red:0.44, green: 0.44, blue: 0.44, opacity: 1.0))
                .padding(.top, 30.0)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Button(action: {
                 print("button pressed")
             }) {
                if (isRecentIngredientType) {
                    Text("Add")
                    .font(.system(size: 12))
                    .fontWeight(.light)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.trailing)
                    .onTapGesture {
                        withAnimation{
                            self.addSuggestedIngredient(ingredient: self.ingredient)
                        }
                    }
                } else {
                    Text("Remove")
                    .font(.system(size: 12))
                    .fontWeight(.light)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.trailing)
                    .onTapGesture {
                        withAnimation{
                        self.removeSelectedIngredient(ingredient: self.ingredient)
                        }
                    }
                }
            }
            .padding(.top, 20)
            .padding(.trailing, 12)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(width: 112, height: 112, alignment: .leading)
        .background(Color.white)
        .cornerRadius(19)
    }
    
    func addSuggestedIngredient(ingredient: String) {
        // Check if ingredient is not already present in the selected ingredient list. If it is, then we don't add it
        // (prevent same ingredient appear twice)
        if (!self.userData.selectedIngredients.contains(ingredient)) {
            self.userData.selectedIngredients.append(ingredient)
        }
        self.userData.recentIngredients.remove(at: self.userData.recentIngredients.firstIndex(of: ingredient) ?? 0)
    }
    
    func removeSelectedIngredient(ingredient: String) {
        self.userData.selectedIngredients.remove(at: self.userData.selectedIngredients.firstIndex(of: ingredient) ?? 0)
    }
}

struct IngredientRow_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            IngredientRow(items: userData.recentIngredients, isRecentIngredientType: false)
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
