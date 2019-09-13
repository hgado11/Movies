//
//  UIImageView+Extension.swift
//  Movies
//
//  Created by Hassan Gado on 9/13/19.
//  Copyright © 2019 Hassan Gadou. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func load(url: URL) {
        debugPrint("Load Image: ", url)
        
        if let catchedImage = imageCache.object(forKey: url as AnyObject) {
            self.image = (catchedImage as! UIImage)
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: url as AnyObject)
                        self?.image = image
                    }
                }
            }
        }
    }
    
}

