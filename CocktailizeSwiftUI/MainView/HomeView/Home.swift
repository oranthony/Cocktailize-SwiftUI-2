//
//  Home.swift
//  CocktailizeSwiftUI
//
//  Created by anthony loroscio on 01/04/2020.
//  Copyright © 2020 anthony loroscio. All rights reserved.
//

import SwiftUI

/**
 Home view displaying the illustration and start button leading to MainView.
 */
struct CocktailizeHome: View {
    @EnvironmentObject var userData: UserData
    @ObservedObject var model = HomeViewModel()
    
    /**
     Retreive and store favorites cocktails in userData environment object
     */
    func getFavoritesCocktails() {
        userData.favoritesCocktails = model.loadFavoritesCocktails()
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                Image("Background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                    ZStack {
                        VStack {
                            Text("Cocktailize")
                                .font(.system(size: 50))
                                .fontWeight(.medium)
                                .foregroundColor(Color(red:0.44, green:0.44, blue:0.44, opacity:1))
                                .padding(.top, geo.size.height / 17)
                            
                            Spacer()
                            
                            Image("Cocktail-image")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geo.size.width / 2.5)
                            
                            Spacer()
                            
                            Text("Find the cocktails you can make with the ingredients you have.")
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40.0)
                                .foregroundColor(Color(red:0.5, green:0.5, blue:0.5, opacity:1))
                            
                            Spacer()
                            
                            NavigationLink(destination: MainView()) {
                                Text("Start")
                                    .fontWeight(.semibold)
                                    .font(.title)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .padding(.vertical, 9.0)
                                    .foregroundColor(Color(red:0.44, green:0.44, blue:0.44, opacity:1))
                                    .background(Color(red:0.49, green:0.87, blue:0.94, opacity:0.99))
                                    .cornerRadius(40)
                                    .shadow(radius: 2)
                                    .padding(.horizontal, 50.0)
                            }
                            .padding(.bottom, geo.size.height / 20)
                            .navigationBarBackButtonHidden(true) // TODO: remove ?
                        }
                    }
                }
                .navigationBarHidden(true)
               .navigationBarTitle(Text("Home"))
               .edgesIgnoringSafeArea([.top, .bottom])
        }
        .onAppear() {
            self.getFavoritesCocktails()
        }
    }
}

struct CocktailizeHome_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            CocktailizeHome()
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
            .environmentObject(userData)
        }
    }
}
