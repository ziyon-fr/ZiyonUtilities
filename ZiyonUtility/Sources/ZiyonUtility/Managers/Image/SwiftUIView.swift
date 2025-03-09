//
//  SwiftUIView.swift
//  ZiyonUtility
//
//  Created by Elioene Silves Fernandes on 09/03/2025.
//

import SwiftUI
import PhotosUI


/// A singleton class responsible for handling image-related operations,
/// including image retrieval, conversion to Base64, compression, and resizing.
///
/// This class conforms to `ObservableObject`, allowing it to be used with SwiftUI.
public final class ImageManager: ObservableObject {

    /// Shared singleton instance of `ImageManager`
    public static let shared = ImageManager()

    /// Private initializer to prevent external instantiation.
    private init() {}

    /// The last retrieved or processed image.
    @Published public var returnedImage: UIImage? = nil

    /// Retrieves an image from a `PhotosPickerItem` and converts it to `UIImage`.
    ///
    /// - Parameter image: The selected `PhotosPickerItem` from SwiftUI's `PhotosPicker`.
    /// - Returns: The loaded `UIImage`, or `nil` if an error occurs.
    public func getImage(image: PhotosPickerItem?) async throws -> UIImage? {
        guard let image else { return nil }

        do {
            guard let data = try await image.loadTransferable(type: Data.self),
                  let result = UIImage(data: data) else { return nil }

            returnedImage = result
        } catch {
            print("From: \(Self.self) - Error getting image:", error.localizedDescription)
        }
        return returnedImage
    }

    /// Converts a `UIImage` into a Base64-encoded string.
    ///
    /// - Parameter image: The `UIImage` to be converted.
    /// - Returns: A Base64-encoded string representation of the image, or `nil` if conversion fails.
    public func convertImageToBase64(image: UIImage?) -> String? {
        guard let image else {
            print("From: \(Self.self) - No image found")
            return nil
        }

        guard let imageData = image.pngData() else {
            print("From: \(Self.self) - Error converting image to data")
            return nil
        }

        let base64String = imageData.base64EncodedString(options: .lineLength64Characters)
        print("From: \(Self.self) - Successfully converted image to Base64")
        return base64String
    }
    /// Converts a `Base64` into a UIImage.
    ///
    /// - Parameter base64: The `Sring` to be converted.
    /// - Returns: A UIImage  or `nil` if conversion fails.
    public func convertBase64ToImage(base64: String?) -> UIImage? {
        guard let base64 else {
            print("From: \(Self.self) - No base64 found")
            return nil
        }
        if let avatarData = Base64DataManager.default.convertBase64ToData(stringBase64: base64) {
            let uiImage = UIImage(data: avatarData)
            print("From: \(Self.self) - Successfully converted Base64 to image")
            return uiImage
        } else {

            return nil
        }
    }

    /// Converts a Base64-encoded string back to `Data`.
    ///
    /// - Parameter stringBase64: The Base64 string representation of the image.
    /// - Returns: The decoded `Data`, or `nil` if conversion fails.
    public func convertBase64ToData(stringBase64: String?) -> Data? {
        guard let stringBase64 else {
            print("From: \(Self.self) - No Base64 string found")
            return nil
        }

        guard let dataDecoded = Data(base64Encoded: stringBase64, options: .ignoreUnknownCharacters) else {
            print("From: \(Self.self) - Error converting Base64 string to data")
            return nil
        }

        return dataDecoded
    }

    /// Compresses and converts an image to a Base64-encoded string.
    ///
    /// - Parameters:
    ///   - image: The `UIImage` to be compressed.
    ///   - compressionQuality: The compression quality (default is `0.5`).
    ///   - targetSize: The optional target size for resizing before compression.
    /// - Returns: A Base64 string representation of the compressed image, or `nil` if conversion fails.
    public func compressAndConvertImageBase64(image: UIImage?, compressionQuality: CGFloat = 0.5, targetSize: CGSize? = nil) -> String? {
        guard let image else {
            print("From: \(Self.self) - No image found")
            return nil
        }

        /// Resize image if a target size is provided
        let resizedImage = targetSize.map { resizeImage(image, size: $0) } ?? image

        /// Compress the image to JPEG format
        guard let imageData = resizedImage?.jpegData(compressionQuality: compressionQuality) else {
            print("From: \(Self.self) - Error compressing image")
            return nil
        }

        let base64String = imageData.base64EncodedString(options: .lineLength64Characters)
        print("From: \(Self.self) - Successfully converted compressed image to Base64")
        return base64String
    }

    /// Stores an image based on the specified storage type.
    ///
    /// - Parameter type: The storage type, either `.base64` or `.url`.
    /// - Note: This function is currently a placeholder and should be implemented.
    #warning("Implement storage methods")
    public func storeImage(storage type: ImageStorageType) {
        switch type {
        case .url:
            break
        case .base64:
            break
        }
    }

    /// Resizes an image to fit within a given size while maintaining its aspect ratio.
    ///
    /// - Parameters:
    ///   - image: The `UIImage` to resize.
    ///   - size: The target `CGSize` for the image.
    /// - Returns: A resized `UIImage`, or `nil` if resizing fails.
    public func resizeImage(_ image: UIImage?, size: CGSize) -> UIImage? {
        guard let image else {
            print("\(#function): Failed to resize image. Image is nil.")
            return nil
        }

        let aspectSize = image.size.aspectFit(to: size)

        print("\(#function): Resizing image... Target size: \(size), Aspect size: \(aspectSize), Original size: \(image.size)")

        let renderer = UIGraphicsImageRenderer(size: aspectSize)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: aspectSize))
        }

        print("\(#function): Resized image successfully. Aspect size: \(aspectSize), Original size: \(image.size), Resized image: \(resizedImage)")

        return resizedImage
    }
}

/// An enum representing different storage types for images.
public enum ImageStorageType {
    /// Recommended for smaller images (below **1MB**).
    /// The image will be stored as a Base64-encoded string in Firestore or Realtime Database.
    case base64

    /// Recommended for larger images.
    /// The image will be uploaded to Firebase Storage, and only its download URL will be saved in Firestore or Realtime Database.
    case url
}

extension CGSize {
    /// Returns a new size that fits within a target size while maintaining the aspect ratio.
    ///
    /// - Parameter size: The target size.
    /// - Returns: A new `CGSize` that fits within the given size while maintaining aspect ratio.
    public func aspectFit(to size: CGSize) -> CGSize {
        let scaleX = size.width / self.width
        let scaleY = size.height / self.height
        let ratio = min(scaleX, scaleY)
        return .init(width: ratio * width, height: ratio * height)
    }
}

