//
//  ImageRepository.swift
//  DevFest
//
//  Created by Brendon Justin on 1/16/17.
//  Copyright © 2017 GDGConferenceApp. All rights reserved.
//

import UIKit

private class LockBox<Wrapped> {
    private let lock = NSLock()
    var wrapped: Wrapped
    
    init(wrapped: Wrapped) {
        self.wrapped = wrapped
    }
    
    /**
     Prone to deadlocking with careless use.
     */
    func withLock<U>(block: (inout Wrapped) -> U) -> U {
        lock.lock()
        let result = block(&wrapped)
        lock.unlock()
        return result
    }
}

class ImageRepository {
    private let urlSession: URLSession
    private let cacheDirectory: URL
    private let fileManager: FileManager
    
    private var imagesByURL = LockBox(wrapped: [URL:UIImage]())
    
    init(urlSession: URLSession, cacheDirectory: URL, fileManager: FileManager = FileManager.default) {
        self.urlSession = urlSession
        self.cacheDirectory = cacheDirectory
        self.fileManager = fileManager
    }
    
    /**
     Get an image for the given URL. If an image is already downloaded, return that.
     In the case of an already available image, `completion` will never be called.
     
     If no image is already available, no image will be returned, and we will attempt
     to download the image.
     
     Multiple calls to this method may be inefficient, but will not clear a cached image
     if any of those calls succeeds in downloading it.
     */
    func image(at url: URL, completion: @escaping (UIImage?) -> Void) -> (UIImage?, URLSessionTask?) {
        if let image = imagesByURL.withLock(block: { $0[url] }) {
            return (image, nil)
        }
        
        let filename = cacheFilename(for: url)
        let cachedImageURL = cacheDirectory.appendingPathComponent(filename)
        let cachedImagePath = cachedImageURL.path
        if fileManager.fileExists(atPath: cachedImagePath), let image = UIImage(contentsOfFile: cachedImagePath) {
            imagesByURL.withLock {
                $0[url] = image
            }
            return (image, nil)
        }
        
        let task = urlSession.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else {
                return
            }
            
            guard let data = data else {
                if let error = error {
                    NSLog("Error downloading image: \(error) at URL: \(url)")
                }
                
                completion(nil)
                return
            }
            
            guard let image = UIImage(data: data) else {
                NSLog("Couldn't create image from data at URL: \(url)")
                completion(nil)
                return
            }
            
            // Cache the image data to disk before returning it
            strongSelf.fileManager.createFile(atPath: cachedImagePath, contents: data, attributes: nil)
            strongSelf.imagesByURL.withLock {
                $0[url] = image
            }
            completion(image)
        }
        
        task.resume()
        return (nil, task)
    }
}

private extension ImageRepository {
    /**
     The filename to use when caching an image at `url` to disk.
     */
    func cacheFilename(for url: URL) -> String {
        let allowedSet = CharacterSet.alphanumerics
        let absoluteString = url.absoluteString
        if let percentEncoded = absoluteString.addingPercentEncoding(withAllowedCharacters: allowedSet) {
            return percentEncoded
        } else {
            // Per http://stackoverflow.com/a/33558934/1610271 some strings can return nil for `addingPercentEncoding(...)`,
            // so fall back to something reasonably likely to be unique.
            return url.lastPathComponent + "\(url.hashValue)"
        }
    }
}
