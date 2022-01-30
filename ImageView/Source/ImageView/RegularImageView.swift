//
//  RegularImageView.swift
//  ImageView
//
//  Created by Mathtender on 30.01.22.
//

import UIKit

class RegularImageView: UIImageView, ImageView {

    // MARK: - Parameters

    var imageColor: UIColor? {
        didSet { updateImage() }
    }

    // MARK: - Setters

    func set(image: UIImage?, completion: ((Bool) -> Void)? = nil) {
        self.image = image
        updateImage()
        completion?(true)
    }

    func setImage(named imageName: String, completion: ((Bool) -> Void)?) {
        guard let image = UIImage(named: imageName) else {
            assertionFailure("Failed to retrieve image \(imageName) from asset")
            completion?(false)
            return
        }
        set(image: image, completion: completion)
    }

    // MARK: - Color

    private func updateImage() {
        guard image != nil else { return }
        if let imageColor = imageColor {
            image = image?.withRenderingMode(.alwaysTemplate)
            tintColor = imageColor
        } else {
            image = image?.withRenderingMode(.alwaysOriginal)
            tintColor = nil
        }
    }

    // MARK: - Control

    func clear() {
        image = nil
    }
}
