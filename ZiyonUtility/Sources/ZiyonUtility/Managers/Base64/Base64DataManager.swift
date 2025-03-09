//
//  Base64DataManager.swift
//  ZIYON SAC
//
//  Created by Leon Salvatore on 20/02/2024.
//

import SwiftUI

#warning("Update this file")
public final class Base64DataManager {

    static let `default` = Base64DataManager()
    
    public init(){ }

    /// converts an image into base64 data type
    public func convertImageToBase64(image: UIImage?) -> String? {
        ///  safe unwrapping optional, in case it returns nil
        guard let image else {  print("From: \(Self.self) - No Image found")
            return nil }
        /// Convert image into Data format
        guard let imageData = image.pngData()  else { print("From: \(Self.self) - Error converting image into data")
            return nil }
        /// encoding data into base 64 String
        let stringBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        print("From: \(Self.self) - Success converting Image to data String")
        return stringBase64
    }
    
    /// converts base65 data type into data
    public func convertBase64ToData(stringBase64: String?) -> Data? {
        guard let stringBase64 else {  print("From: \(Self.self) - No string base64 found")
            return nil }
        
        guard let dataDecoded = Data(base64Encoded: stringBase64, options: .ignoreUnknownCharacters) else {
            print("From: \(Self.self) - Error converting string into data")
            return nil }
        
        return dataDecoded
        
    }
    
}


