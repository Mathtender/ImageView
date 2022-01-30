//
//  StringExtension.swift
//  ImageView
//
//  Created by Mathtender on 30.01.22.
//

import UIKit
import Foundation

extension String {
    var url: URL? {
        guard let url = URL(string: self),
              UIApplication.shared.canOpenURL(url) else {
            return nil
        }
        return url
    }
}
