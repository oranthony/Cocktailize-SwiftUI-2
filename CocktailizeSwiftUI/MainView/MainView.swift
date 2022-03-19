//
//  CocktailSearch.swift
//  CocktailizeSwiftUI
//
//  Created by anthony loroscio on 02/04/2020.
//  Copyright © 2020 anthony loroscio. All rights reserved.
//

import SwiftUI

// Share function with child view (SearchView) to trigger cocktails search
struct StartSearchFunctionKey: EnvironmentKey {
    static let defaultValue: (() -> Void)? = nil
}

extension EnvironmentValues {
    var startSearchFunction: (() -> Void)? {
        get { self[StartSearchFunctionKey.self] }
        set { self[StartSearchFunctionKey.self] = newValue }
    }
}


/**
 MainView is parent of :
    - SearchView
    - ResultView
    - FavoritesCocktailView
 The main view is basically a search bar, then depending on the app state (user input search, display result, display favorites) it displays the right child view.
 The REST API call to retreive cocktails infotmation is made in MainViewModel.
 */
struct MainView: View {
    @EnvironmentObject var userData: UserData
    @State private var ingredientSearchBarContent = ""
    @State private var isSearchBarFocused = false
    @State var isSearchHidden = false
    @State var isResultHidden = true
    @State var isSearchBarHidden = false
    
    let fontColor = Color(red:0.44, green: 0.44, blue: 0.44, opacity: 1.0)
    var isIngredientEnter = false
    
    @ObservedObject var model = MainViewModel()
    
    // Triggered when user click on start on SearchView (via environment key)
    func startSearchFunction() {
        withAnimation {
            isSearchHidden.toggle()
        }
        // Call model load function with param from env object and then display SearchView
        model.loadCocktail(ingredients: userData.selectedIngredients) {result in
            DispatchQueue.main.async {
                //if (result != nil) {
                self.userData.cocktailList = result
                withAnimation {
                    self.isResultHidden.toggle()
                }
            }
            //}
        }
    }
    
    var body: some View {
        NavigationView {
            //TODO: Remove geometry reader ?
            GeometryReader { geo in
                Image("Background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                ZStack {
                    VStack(alignment: .leading) {
                        if (!self.isSearchHidden) {
                            Text("Search ingredients")
                                .font(.largeTitle)
                                .foregroundColor(self.fontColor)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 30.0)
                                .transition(.asymmetric(insertion: AnyTransition.move(edge: .top).combined(with: .opacity), removal: AnyTransition.move(edge: .top).combined(with: .opacity)))
                        }
                        
                        HStack {
                            HStack {
                                Image("Search-icon")
                                TextField("rum", text: self.$ingredientSearchBarContent, onEditingChanged: { (editingChanged) in
                                    if editingChanged {
                                        self.isSearchBarFocused = true
                                        if (self.isSearchHidden) {
                                            withAnimation {
                                                self.isSearchHidden.toggle()
                                                self.isResultHidden.toggle()
                                            }
                                        }
                                    } else {
                                        self.isSearchBarFocused = false
                                    }
                                }, onCommit: {
                                    self.userData.selectedIngredients.append(self.ingredientSearchBarContent)
                                    self.ingredientSearchBarContent = ""
                                    self.isSearchBarFocused = false
                                })
                                
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(self.fontColor)
                                    .opacity(self.ingredientSearchBarContent == "" ? 0 : 1)
                                    .onTapGesture { self.ingredientSearchBarContent = "" }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 35, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 20).fill(Color.white))
                                .padding(.top, -10)
                                .padding(.leading, 30.0)
                                .shadow(radius: 4)
                            
                            if (self.isSearchBarFocused) {
                                Text("Cancel")
                                    .frame(width: 70, alignment: .center)
                                    .onTapGesture {
                                        self.dismissKeyboard()
                                        self.isSearchBarFocused = false
                                        self.ingredientSearchBarContent = ""
                                }
                                .padding(.top, -15)
                                .padding(.trailing, 10)
                            } else {
                                NavigationLink(destination: FavoritesCocktailsView()) {
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 30.0))
                                        .foregroundColor(Color.pink)
                                        .frame(width: 40, alignment: .center)
                                        .padding(.top, -10)
                                        .padding(.trailing, 10)
                                }
                            }
                        }
                        
                        if (!self.isSearchHidden) {
                            SearchView().transition(.move(edge: .leading))
                        }
                        
                        if (!self.isResultHidden && !(self.userData.cocktailList?.isEmpty ?? true)) {
                            CocktailResult(model: CocktailResultViewModel(items: self.userData.cocktailList ?? [])).transition(.move(edge: .trailing))
                                .onDisappear(perform: {
                                    print("disappear")
                                })
                        }
                    }
                }
                .padding(.vertical, 20.0)
                
                if (!self.isResultHidden && (self.userData.cocktailList?.isEmpty ?? true)) {
                    Text("No cocktails found")
                        .position(x: UIScreen.main.bounds.size.width / 2, y: (UIScreen.main.bounds.size.height / 2) - 50)
                        .multilineTextAlignment(.center)
                        .frame(alignment: .center)
                }
            }
            .hiddenNavigationBarStyle()
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .environment(\.startSearchFunction, startSearchFunction)
    }
    
    
    func dismissKeyboard() {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow?.endEditing(true)
    }
}

struct CocktailSearch_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            MainView()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
                .environmentObject(userData)
        }
    }
}
