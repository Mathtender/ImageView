//
//  SVGKitProcessor.swift
//  ImageView
//
//  Created by Mathtender on 30.01.22.
//

import UIKit
import Kingfisher
import SVGKit

struct SVGKitProcessor: ImageProcessor {

    let identifier = "svgprocessor"

    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image
        case .data(let data):
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
}
