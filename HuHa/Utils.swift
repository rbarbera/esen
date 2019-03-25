//
//  Utils.swift
//  HuHa
//
//  Created by Barbera Cordoba, Rafael on 02/04/2019.
//  Copyright © 2019 Barbera Cordoba, Rafael. All rights reserved.
//

import UIKit

extension UIImage {
    public static func solid(_ color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        return UIGraphicsImageRenderer(bounds: rect)
            .image { context in
                color.setFill()
                context.fill(rect)
        }
    }
}
