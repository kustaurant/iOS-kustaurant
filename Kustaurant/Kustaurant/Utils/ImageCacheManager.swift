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

    public func loadImage(from url: URL, targetWidth: CGFloat? = nil, defaultImage: UIImage? = nil, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = url.absoluteString as NSString
        
        if let cachedImage = cache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                DispatchQueue.main.async {
                    completion(defaultImage)
                }
                return
            }
            
            let resizedImage: UIImage?
            if let targetWidth {
                resizedImage  = image.resized(to: targetWidth)
            } else {
                resizedImage = image
            }
            
            DispatchQueue.main.async {
                completion(resizedImage)
            }
        }.resume()
    }
}
