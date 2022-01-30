//
//  ImageLoaderProtocol.swift
//  ImageView
//
//  Created by Mathtender on 30.01.22.
//

import Foundation

protocol ImageLoader {
    func loadImage(url: URL, successHandler: @escaping ((Image) -> Void), errorHandler: @escaping (() -> Void))
    func cancelLoading()
}
