//
//  ImageCacheManager.swift
//  Kustaurant
//
//  Created by 송우진 on 7/19/24.
//

import UIKit

public class ImageCacheManager {
    public static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    public func loadImage(from url: URL, targetWidth: CGFloat, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = url.absoluteString as NSString
        
        if let cachedImage = cache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let resizedImage = image.resized(to: targetWidth)
            
            
            if let resizedImage = resizedImage {
                self.cache.setObject(resizedImage, forKey: cacheKey)
            }
            
            DispatchQueue.main.async {
                completion(resizedImage)
            }
        }.resume()
    }
}
