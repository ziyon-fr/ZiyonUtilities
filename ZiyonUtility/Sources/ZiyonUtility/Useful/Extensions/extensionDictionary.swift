//
//  SwiftUIView.swift
//  
//
//  Created by Elioene Silves Fernandes on 21/03/2024.
//

import SwiftUI

public extension Dictionary {
    
    var jsonData: Data? {
        let result = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
        return result
    }
    
    func convertToJSONString()-> String? {
        if let jsonData,
           let stringValue = String(data: jsonData, encoding: .utf8) {
            return stringValue
        }
        return nil
    }
}



