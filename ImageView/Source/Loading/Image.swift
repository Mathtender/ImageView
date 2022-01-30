//
//  Image.swift
//  ImageView
//
//  Created by Mathtender on 30.01.22.
//

import SVGKit

struct Image {
    let svgImage: SVGKImage?
    let regularImage: UIImage?

    init(_ image: UIImage) {
        if let svgImage = image.svgImage {
            self.svgImage = svgImage
            self.regularImage = nil
        } else {
            self.regularImage = image
            self.svgImage = nil
        }
    }
}
