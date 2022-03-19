//
//  FavoritesCocktailsView.swift
//  CocktailizeSwiftUI
//
//  Created by anthony loroscio on 28/04/2020.
//  Copyright © 2020 anthony loroscio. All rights reserved.
//

import SwiftUI

struct FavoritesCocktailsView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var model = FavoritesCocktailsViewModel()
    
    init() {
        let fontColor = UIColor(red:0.44, green: 0.44, blue: 0.44, alpha: 1.0)
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: fontColor]
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    Image("Background")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .bottom, spacing: 0) {
                            
                            //TODO : SAFE PBROBELM
                            ForEach(self.userData.favoritesCocktails.items ?? [], id: \.self) { ingredient in
                                CocktailView(model: CocktailViewModel(cocktail: ingredient))
                                    .environmentObject(self.userData)
                                    .frame(width: geo.size.width * 0.90, height: geo.size.height * 0.99, alignment: .bottom)
                                    .shadow(radius: 5)
                            }
                            .offset(x: 30, y: 0)
                        }
                    }
                    if (self.userData.favoritesCocktails.items?.isEmpty ?? true) {
                        Text("You have no favorites cocktails")
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                self.mode.wrappedValue.dismiss()
            }){
                HStack {
                    Image(systemName: "arrow.left")
                    Text("Back")
                }
            })
                .navigationBarTitle("Favorites", displayMode: .inline)
        }
        .hiddenNavigationBarStyle()
    }
}

struct FavoritesCocktailsView_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            FavoritesCocktailsView()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
                .environmentObject(userData)
        }
    }
}
