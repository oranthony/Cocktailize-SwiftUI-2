//
//  CocktailResult.swift
//  CocktailizeSwiftUI
//
//  Created by anthony loroscio on 09/04/2020.
//  Copyright © 2020 anthony loroscio. All rights reserved.
//

import SwiftUI
import Combine

struct LazyView<CocktailResult: View>: View {
    var content: () -> CocktailResult
    var body: some View {
       self.content()
    }
}

/**
 ResultView display the cocktails found from the API in an horizontal scroll list.
 Each element of the list is a CocktailView.
 */
struct CocktailResult: View {
    //@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userData: UserData
    @ObservedObject var model: CocktailResultViewModel
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .bottom, spacing: 0) {
                        //TODO : SAFE PBROBELM
                        ForEach(self.model.items, id: \.self) { ingredient in
                            CocktailView(model: CocktailViewModel(cocktail: ingredient))
                                .frame(width: geo.size.width * 0.90, height: geo.size.height * 0.99, alignment: .bottom)
                                .shadow(radius: 5)
                        }
                        .offset(x: 30, y: 0)
                    }
                }
            }
        }
    }
}

struct CocktailResult_Previews: PreviewProvider {
    static var previews: some View {
        return ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            CocktailResult(model: CocktailResultViewModel())
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
