//
//  KingfisherImageLoader.swift
//  ImageView
//
//  Created by Mathtender on 30.01.22.
//

import Kingfisher

class KingfisherImageLoader: ImageLoader {

    // MARK: - Parameters

    private let supportedImageTypes = ["svg", "png", "jpg", "jpeg"]

    private var imageTask: DownloadTask?
    private var successHandler: ((Image) -> Void)?
    private var errorHandler: (() -> Void)?

    // MARK: - Deinitialization

    deinit {
        self.imageTask?.cancel()
    }

    // MARK: - Loading

    func loadImage(url: URL, successHandler: @escaping ((Image) -> Void), errorHandler: @escaping (() -> Void)) {
        guard !url.pathExtension.isEmpty else {
            assertionFailure("Path extension should not be empty")
            errorHandler()
            return
        }
        guard supportedImageTypes.contains(url.pathExtension.lowercased()) else {
            assertionFailure("Unsupported image type")
            errorHandler()
            return
        }

        self.cancelLoading()
        self.successHandler = successHandler
        self.errorHandler = errorHandler
        let resource = ImageResource(downloadURL: url)

        self.getImageFromCache(cacheKey: resource.cacheKey) { [weak self] in
            if resource.downloadURL.pathExtension == "svg" {
                self?.downloadSvgImage(resource: resource)
            } else {
                self?.downloadRegularImage(resource: resource)
            }
        }
    }

    func cancelLoading() {
        self.imageTask?.cancel()
    }

    // MARK: - Cache

    private func getImageFromCache(cacheKey: String, error: @escaping (() -> Void)) {
        ImageCache.default.retrieveImage(forKey: cacheKey,
                                         options: [.onlyFromCache, .cacheSerializer(SVGKitCacheSerializer())],
                                         callbackQueue: .mainAsync) { [weak self] result in
            switch result {
            case .success(let result):
                guard let image = result.image else { fallthrough }
                self?.successHandler?(Image(image))
            default:
                error()
            }
        }
    }

    // MARK: - Download

    private func downloadSvgImage(resource: ImageResource) {
        self.retrieveImage(resource: resource, options: [
            .processor(SVGKitProcessor()),
            .cacheOriginalImage,
            .cacheSerializer(SVGKitCacheSerializer())
        ]) { [weak self] image in
            self?.successHandler?(image)
        } error: { [weak self] in
            self?.errorHandler?()
        }
    }

    private func downloadRegularImage(resource: ImageResource) {
        self.retrieveImage(resource: resource) { [weak self] image in
            self?.successHandler?(image)
        } error: { [weak self] in
            self?.errorHandler?()
        }
    }

    private func retrieveImage(resource: ImageResource, options: KingfisherOptionsInfo? = nil,
                               success: @escaping ((Image) -> Void), error: @escaping (() -> Void)) {
        imageTask = KingfisherManager.shared.retrieveImage(
            with: resource,
            options: options,
            downloadTaskUpdated: { self.imageTask = $0 },
            completionHandler: { [weak self] result in
                CallbackQueue.mainCurrentOrAsync.execute {
                    self?.imageTask = nil
                    switch result {
                    case .success(let value):
                        success(Image(value.image))
                    default:
                        error()
                    }
                }
            }
        )
    }
}
