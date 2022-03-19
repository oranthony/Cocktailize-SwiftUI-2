//
//  SearchView.swift
//  CocktailizeSwiftUI
//
//  Created by anthony loroscio on 11/04/2020.
//  Copyright © 2020 anthony loroscio. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.startSearchFunction) var startSearchFunction
    @EnvironmentObject var userData: UserData
    //@ObservedObject var fetcher: CocktailFetcher
    let fontColor = Color(red:0.44, green: 0.44, blue: 0.44, opacity: 1.0)
    
    var body: some View {
        VStack(alignment: .leading) {
            SelectedIngredientsRow()
                .padding(.top, 30)
                .buttonStyle(PlainButtonStyle())
            
            if (self.userData.recentIngredients.count > 0) {
                Text("Recent ingredients")
                    .font(.title)
                    .foregroundColor(self.fontColor)
                    .multilineTextAlignment(.leading)
                    .padding([.leading, .top], 30.0)
            }
            
            RecentIngredientRow()
                .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            if (self.userData.selectedIngredients.count == 0) {
                Text("Use the search bar to add ingredients")
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding([.leading, .trailing], 30)
            } else {
                Text("Search")
                    .fontWeight(.semibold)
                    .font(.title)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.vertical, 9.0)
                    .foregroundColor(Color(red:0.44, green:0.44, blue:0.44, opacity:1))
                    .background(Color(red:0.49, green:0.87, blue:0.94, opacity:0.99))
                    .cornerRadius(40)
                    .shadow(radius: 2)
                    .padding(.horizontal, 50.0)
                    .onTapGesture {
                        // Call parent view to trigger cocktails search
                        self.startSearchFunction?()
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        //let fetcher = CocktailFetcher()
        return SearchView()
            .environmentObject(userData)
    }
}
