//
//  UIImageExtension.swift
//  ImageView
//
//  Created by Mathtender on 30.01.22.
//

import SVGKit

private var SVGKImageKey: UInt8 = 0

extension UIImage {
    var svgImage: SVGKImage? {
        get { objc_getAssociatedObject(self, &SVGKImageKey) as? SVGKImage }
        set { objc_setAssociatedObject(self, &SVGKImageKey, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}
