import UIKit

enum ImageLoadingError: Error {
    case noImageFound
    case invalidResponse
}

struct FetchImageResponse {
    let image: UIImage
    let requestUrl: URL
}

protocol ImageManager {
    var imageCache: NSCache<NSString, UIImage> { get }
}


final class DefaultImageManager: ImageManager {
    
    static let sharedInstance: DefaultImageManager = DefaultImageManager()
    
    let imageCache = NSCache<NSString, UIImage>()
    
    private init() {
        // NO - OP
    }
}

extension UIImageView {
    
    func loadImage(url: URL,
              placeholder: UIImage? = nil,
              completionHandler: ((Result<FetchImageResponse, ImageLoadingError>) -> ())? = nil) {
        
        let imageCache = DefaultImageManager.sharedInstance.imageCache
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completionHandler?(.success(FetchImageResponse(image: cachedImage, requestUrl: url)))
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                guard let fetchedImage = UIImage(data: try Data(contentsOf: url)) else {
                    DispatchQueue.main.async {
                        completionHandler?(.failure(.noImageFound))
                    }
                    return
                }
                imageCache.setObject(fetchedImage, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    completionHandler?(.success(FetchImageResponse(image: fetchedImage, requestUrl: url)))
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler?(.failure(.invalidResponse))
                }
            }
            
        }
    }
}

