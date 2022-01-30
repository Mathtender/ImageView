//
//  SVGKImageExtension.swift
//  ImageView
//
//  Created by Mathtender on 30.01.22.
//

import SVGKit

extension SVGKImage {
    var copy: SVGKImage? {
        guard let source = source?.copy() as? SVGKSource,
              let image = SVGKImage(source: source) else {
            return nil
        }
        image.size = size
        return image
    }

    func filledWithColor(_ color: UIColor) -> SVGKImage? {
        guard let copy = copy else { return nil }
        copy.fillWithColor(color)
        return copy
    }

    func fillWithColor(_ color: UIColor) {
        guard let layer = caLayerTree else { return }
        fillLayer(layer, color: color.cgColor)
    }

    private func fillLayer(_ layer: CALayer, color: CGColor) {
        if let layer = layer as? CAShapeLayer {
            if layer.strokeColor != nil {
                layer.strokeColor = color
            }
            if layer.fillColor != nil {
                layer.fillColor = color
            }
            layer.opacity = 1
        }
        layer.sublayers?.forEach { fillLayer($0, color: color) }
    }
}
