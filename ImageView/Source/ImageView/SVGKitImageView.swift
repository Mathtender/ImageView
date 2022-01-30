//
//  SVGKitImageView.swift
//  ImageView
//
//  Created by Mathtender on 30.01.22.
//

import SVGKit

class SVGKitImageView: SVGKFastImageView, ImageView {

    // MARK: - Parameters

    private var originalImage: SVGKImage?

    var imageColor: UIColor? {
        didSet { updateImage() }
    }

    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let imageSize = image?.size, bounds != .zero,
              imageSize.height > bounds.height || imageSize.width > bounds.width else {
            return
        }
        image.size = bounds.size
        invalidateIntrinsicContentSize()
    }

    // MARK: - Setters

    func set(image: SVGKImage, completion: ((Bool) -> Void)? = nil) {
        originalImage = image.copy
        self.image = image
        updateImage()
        completion?(true)
    }

    func setImage(path: String, completion: ((Bool) -> Void)?) {
        guard Bundle.main.path(forResource: path, ofType: nil) != nil else {
            assertionFailure("Failed to find image at path \(path)")
            completion?(false)
            return
        }
        guard let image = SVGKImage(named: path) else {
            assertionFailure("Failed make image from path \(path)")
            completion?(false)
            return
        }
        set(image: image, completion: completion)
    }

    func setImage(data: Data, completion: ((Bool) -> Void)?) {
        guard let image = SVGKImage(data: data) else {
            assertionFailure("Failed make image from data \(data)")
            completion?(false)
            return
        }
        set(image: image, completion: completion)
    }

    // MARK: - Color

    private func updateImage() {
        guard image != nil else { return }
        if let imageColor = imageColor {
            image = originalImage?.filledWithColor(imageColor)
        } else {
            image = originalImage?.copy
        }
        invalidateIntrinsicContentSize()
        setNeedsLayout()
        layoutIfNeeded()
    }

    // MARK: - Control

    func clear() {
        image = nil
        originalImage = nil
    }
}
