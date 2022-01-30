//
//  ImageContainer.swift
//  ImageView
//
//  Created by Mathtender on 30.01.22.
//

import UIKit
import SVGKit

class ImageContainer: UIView {

    enum ImageType {
        case regular
        case svg
    }

    // MARK: - Parameters

    private let imageLoader: ImageLoader

    private var completion: ((Bool) -> Void)?

    private var currentImageType: ImageType? {
        didSet {
            clear()
            regularImageView.isHidden = currentImageType == .svg
            svgImageView.isHidden = currentImageType == .regular
        }
    }

    var imageColor: UIColor? {
        get { activeImageView?.imageColor }
        set { activeImageView?.imageColor = newValue }
    }
    var imageSize: CGSize? {
        didSet { setNeedsUpdateConstraints() }
    }

    // MARK: - GUI Variables

    private lazy var regularImageView: RegularImageView = {
        let view = RegularImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var svgImageView: SVGKitImageView = {
        let view = SVGKitImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var activeImageView: ImageView? {
        switch currentImageType {
        case .regular:
            return regularImageView
        case .svg:
            return svgImageView
        default:
            return nil
        }
    }

    // MARK: - Initialization

    init(imageLoader: ImageLoader = KingfisherImageLoader()) {
        self.imageLoader = imageLoader
        super.init(frame: .zero)
        addSubview(regularImageView)
        addSubview(svgImageView)
        setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Constraints

    func setupConstraints() {
        if let imageSize = imageSize {
            NSLayoutConstraint.activate([
                regularImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                regularImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                regularImageView.heightAnchor.constraint(equalToConstant: imageSize.height),
                regularImageView.widthAnchor.constraint(equalToConstant: imageSize.width)
            ])
            NSLayoutConstraint.activate([
                svgImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                svgImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                svgImageView.heightAnchor.constraint(equalToConstant: imageSize.height),
                svgImageView.widthAnchor.constraint(equalToConstant: imageSize.width)
            ])
        } else {
            NSLayoutConstraint.activate([
                regularImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                regularImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                regularImageView.topAnchor.constraint(equalTo: topAnchor),
                regularImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
            NSLayoutConstraint.activate([
                svgImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                svgImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }

    // MARK: - Setters

    func set(svgImage: SVGKImage, completion: ((Bool) -> Void)? = nil) {
        currentImageType = .svg
        svgImageView.set(image: svgImage, completion: completion)
    }

    func set(svg: String, completion: ((Bool) -> Void)? = nil) {
        currentImageType = .svg
        svgImageView.setImage(path: svg, completion: completion)
    }

    func set(svgData: Data, completion: ((Bool) -> Void)? = nil) {
        currentImageType = .svg
        svgImageView.setImage(data: svgData, completion: completion)
    }

    func set(assetName: String, completion: ((Bool) -> Void)? = nil) {
        currentImageType = .regular
        regularImageView.setImage(named: assetName, completion: completion)
    }

    func set(image: UIImage, completion: ((Bool) -> Void)? = nil) {
        currentImageType = .regular
        regularImageView.set(image: image, completion: completion)
    }

    func set(imageUrl: URL, completion: ((Bool) -> Void)? = nil) {
        switch imageUrl.pathExtension {
        case let pathExtension where pathExtension.isEmpty:
            assertionFailure("Path extension should not be empty")
        case let pathExtension where pathExtension.lowercased() == "svg":
            currentImageType = .svg
        default:
            currentImageType = .regular
        }
        imageLoader.loadImage(url: imageUrl) { [weak self] image in
            if let svgImage = image.svgImage {
                self?.set(svgImage: svgImage, completion: completion)
            } else if let regularImage = image.regularImage {
                self?.set(image: regularImage, completion: completion)
            } else {
                completion?(false)
            }
        } errorHandler: {
            completion?(false)
        }
    }

    func set(image: String, completion: ((Bool) -> Void)? = nil) {
        if let url = image.url {
            set(imageUrl: url, completion: completion)
        } else if image.hasSuffix(".svg") {
            set(svg: image, completion: completion)
        } else {
            set(assetName: image, completion: completion)
        }
    }

    // MARK: - Control

    func clear() {
        regularImageView.clear()
        svgImageView.clear()
    }
}
