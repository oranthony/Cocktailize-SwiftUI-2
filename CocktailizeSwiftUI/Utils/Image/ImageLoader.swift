//
//  ImageLoader.swift
//  CocktailizeSwiftUI
//
//  Created by anthony loroscio on 13/04/2020.
//  Copyright © 2020 anthony loroscio. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var urlString: String?
    var imageCache = ImageCache.getImageCache()
    /*var data: UIImage? {
        didSet {
            //didChange.send(data)
            super.data = data
        }
    }*/
     @Published var data: UIImage?
    

    init(urlString:String, completionHandler: @escaping (_ result: UIImage) -> Void) {
        self.urlString = urlString
        
        if loadImageFromCache() {
            print("Cache hit")
            return
        }
        
        
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            //TODO: move else where, not in main
            let image = UIImage(data: data) ?? UIImage()
            DispatchQueue.main.async {
                self.data = image
                completionHandler(image)
            }
        }
        task.resume()

    }
    
    func loadImageFromCache() -> Bool {
        guard let urlString = urlString else {
            return false
        }
        
        guard let cacheImage = imageCache.get(forKey: urlString) else {
            return false
        }
        
        data = cacheImage
        return true
    }
}

struct ImageView: View {
    @EnvironmentObject var userData: UserData
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()
    var height: CGFloat
    var url: String
    
    var analizedColor = UIColor.gray

    init(withURL url:String, height: CGFloat, completionHandler: @escaping (_ result: UIImage) -> Void) {
        imageLoader = ImageLoader(urlString:url) {result in
            completionHandler(result)
        }
        self.height = height
        self.url = url
    }

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: height)
        }.onReceive(imageLoader.didChange) { data in
            self.image = UIImage(data: data) ?? UIImage()
        }
    }
}

/*class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}*/
