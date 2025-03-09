//
//  ExtensionUIImage.swift
//  ZIYON SAC
//
//  Created by Bruno Moura on 24/03/24.
//

import SwiftUI

public extension UIImage {
    func reduceSize(_ heigth: CGFloat) -> UIImage {
        let scale = heigth / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: heigth)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let result = renderer.image { _ in
            self.draw(in: .init(origin: .zero, size: newSize))
        }
        return result
    }
    
    func compressed(_ newHigth: CGFloat = 200, compressionQuality: CGFloat = 0.5) -> UIImage {
        let resizedImage = self.reduceSize(newHigth)
        resizedImage.jpegData(compressionQuality: compressionQuality)
        return resizedImage
    }
}
