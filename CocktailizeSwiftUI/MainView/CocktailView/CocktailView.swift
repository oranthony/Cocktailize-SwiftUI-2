//
//  CocktailView.swift
//  CocktailizeSwiftUI
//
//  Created by anthony loroscio on 09/04/2020.
//  Copyright © 2020 anthony loroscio. All rights reserved.
//

import SwiftUI
//import ShimmerView

/**
 Display the cocktail information whithin a nice card.
 Meant to be used in CocktailResult view.
 Click on a CocktailView bring the CocktailDetailView to display more detailed information.
 */
struct CocktailView: View {
    @EnvironmentObject var userData: UserData
    @State private var showModal = false
    @ObservedObject var model: CocktailViewModel
    let fontColor = Color(red:0.44, green: 0.44, blue: 0.44, opacity: 1.0)
    
    var body: some View {
        GeometryReader { geo in
            
            ZStack() {
                VStack(alignment: .leading) {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            
                            ZStack(alignment: Alignment.leading) {
                                Text("")
                                    .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.45, alignment: .leading)
                                
                                Text(self.model.cocktail.name ?? "")
                                    .font(.largeTitle)
                                    .foregroundColor(self.fontColor)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: geo.size.width * 0.49, maxHeight: geo.size.height * 0.45, alignment: .leading)
                            }
                        }
                        .padding([.top, .leading])
                        
                        Text(self.model.ingredients)
                            .font(.title)
                            .fontWeight(.light)
                            .multilineTextAlignment(.leading)
                            .padding([.top, .leading])
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .foregroundColor(self.fontColor)
                            .background(Color(self.model.backgroundColor))
                    }
                    .background(Color.white)
                    .frame(maxWidth: geo.size.width * 0.91, maxHeight: geo.size.height * 0.95, alignment: .bottomLeading)
                    .cornerRadius(20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                
                if (self.model.imageLoaded) {
                    self.model.cocktailImage
                        .position(x: geo.size.width * 0.72, y: geo.size.height * 0.19)
                } else {
                    CocktailPath()
                        .position(x: geo.size.width * 0.70, y: geo.size.height * 0.05)
                        .frame(height: UIScreen.main.bounds.size.height * 0.45)
                }
                
            }.onTapGesture {
                self.showModal.toggle()
            }.sheet(isPresented: self.$showModal) {
                CocktailDetailView(showModal: self.$showModal, model: CocktailDetailViewModel(cocktail: self.model.cocktail,  backgroundColor: self.model.backgroundColor))
                    .environmentObject(self.userData)
            }
        }
    }
}

struct CocktailView_Previews: PreviewProvider {
    static var previews: some View {
        let cocktail = CocktailViewModel()
        return ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            CocktailView(model: cocktail)
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
