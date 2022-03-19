//
//  UrlImageModel.swift
//  NewsApp
//
//  Created by SchwiftyUI on 12/29/19.
//  Copyright © 2019 SchwiftyUI. All rights reserved.
//

import Foundation
import SwiftUI
import UIImageColors

class UrlImageModel: ObservableObject {
    @Published var image: UIImage?
    var urlString: String?
    var imageCache = ImageCache.getImageCache()
    @Published var backgroundColor: UIColor?
    
    init(urlString: String?, completionHandler: @escaping (_ result: UIColor?) -> Void) {
        self.urlString = urlString
        self.loadImage(completionHandler: {result in
            completionHandler(result)
            }
        )
    }
    
    func loadImage(completionHandler: @escaping (_ result: UIColor?) -> Void) {
        if loadImageFromCache(completionHandler: {result in
            completionHandler(result)
        }) {
            //print("Cache hit")
            //completionHandler(UIColor.purple)
            return
        }
        
        //print("Cache miss, loading from url")
        loadImageFromUrl(completionHandler: {result in
            completionHandler(nil)
        })
    }
    
    func loadImageFromCache(completionHandler: @escaping (_ result: UIColor) -> Void) -> Bool {
        guard let urlString = urlString else {
            return false
        }
        
        guard let cacheImage = imageCache.get(forKey: urlString) else {
            return false
        }
        
        image = cacheImage
        
        guard let cacheBgColor = imageCache.getBgColor(forKey: urlString) else {
            return false
        }
        completionHandler(cacheBgColor)
        
        return true
    }
    
    func loadImageFromUrl(completionHandler: @escaping (_ result: UIColor) -> Void) {
        guard let urlString = urlString else {
            return
        }
        
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            self.getImageFromResponse(data: data, response: response, error: error, completionHandler: {_ in
                completionHandler(UIColor.yellow)
            })
        }
        task.resume()
    }
    
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping (_ result: UIColor) -> Void) {
        guard error == nil else {
            print("Error: \(error!)")
            return
        }
        guard let data = data else {
            print("No data found")
            return
        }
        
        DispatchQueue.main.async {
            guard let loadedImage = UIImage(data: data) else {
                return
            }
            
            self.imageCache.set(forKey: self.urlString!, image: loadedImage)
            self.image = loadedImage
            
            DispatchQueue.global(qos: .userInitiated).async {
                let color = self.setBackgroundColor(image: loadedImage)
                self.imageCache.setBgColor(forKey: self.urlString!, color: color)
                completionHandler(color)
            }
            

            //self.setBackgroundColor()
        }
    }
    
    /**
     Compute the ideal background color for the cocktail card from the cocktail image
     */
    func setBackgroundColor(image: UIImage) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        var color = UIColor()
        
        // Compute the background color from the cocktail image on the background
        //DispatchQueue.global(qos: .userInitiated).async {
            self.image?.getColors()!.background.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            color = UIColor(hue: hue, saturation: 0.28, brightness: 1, alpha: 1)
            // Update the UI from the main thread
            //DispatchQueue.main.async {
                return color
            //}
           
        //}
    }
}

class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
    
    var bgColorCache = NSCache<NSString, UIColor>()
    
    func getBgColor(forKey: String) -> UIColor? {
        return bgColorCache.object(forKey: NSString(string: forKey))
    }
    func setBgColor(forKey: String, color: UIColor) {
        bgColorCache.setObject(color, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
    
    //private static var bgColor = UIColor()
    /*static func getBgColorCache() -> UIColor {
        return UIColor
    }*/
}
