//
//  SVGKitCacheSerializer.swift
//  ImageView
//
//  Created by Mathtender on 30.01.22.
//

import UIKit
import Kingfisher
import SVGKit

struct SVGKitCacheSerializer: CacheSerializer {
    func data(with image: KFCrossPlatformImage, original: Data?) -> Data? {
        return original
    }

    func image(with data: Data, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        if let image = UIImage(data: data) {
            return image
        } else if let svgImage = SVGKImage(data: data) {
            let uiImage = svgImage.uiImage
            uiImage?.svgImage = svgImage
            return uiImage
        } else {
            return nil
        }
    }
}
