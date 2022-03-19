//
//  UrlImageView.swift
//  NewsApp
//
//  Created by SchwiftyUI on 12/29/19.
//  Copyright © 2019 SchwiftyUI. All rights reserved.
//

import SwiftUI

struct UrlImageView: View {
    @ObservedObject var urlImageModel: UrlImageModel
    var height: CGFloat
    //var bgColor: UIColor
    
    init(urlString: String?, height: CGFloat, completionHandler: @escaping (_ result: UIColor?) -> Void) {
        urlImageModel = UrlImageModel(urlString: urlString, completionHandler: {result in
            completionHandler(result)
        })
        self.height = height
        
        // Get ideal BG color
        //urlImageModel.setBackgroundColor(image: urlImageModel.image?)
    }
    
    var body: some View {
        Image(uiImage: urlImageModel.image ?? UrlImageView.defaultImage!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: height)
            //.frame(width: 100, height: 100)
    }
    
    static var defaultImage = UIImage(named: "Empty")
}

struct UrlImageView_Previews: PreviewProvider {
    static var previews: some View {
        UrlImageView(urlString: nil, height: 0, completionHandler: {_ in })
    }
}
