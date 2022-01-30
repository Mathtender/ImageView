//
//  ImageViewProtocol.swift
//  ImageView
//
//  Created by Mathtender on 30.01.22.
//

import UIKit

protocol ImageView: UIView {
    var imageColor: UIColor? { get set }
    func clear()
}
