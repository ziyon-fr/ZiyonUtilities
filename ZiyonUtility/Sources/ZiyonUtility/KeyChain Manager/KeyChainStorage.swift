//
//  KeyChainStorage.swift
//
//
//  Created by Leon Salvatore on 13/02/2024.
//

import SwiftUI

@propertyWrapper
public struct KeyChainStorage: DynamicProperty {
    
    @State var data: Data?
    var key: String
    var account: String
    
    public var wrappedValue: Data? {
        /// Getting data
        get {KeyChainManager.shared.read(key: key, account: account)}
        /// Updating / Setting keychain Data
       nonmutating set {
           let newData = setdata(newValue)
            KeyChainManager
                .shared
                .save(data: newData, for: key, account: account)
            
            data = newValue
        }
    }
    
    public init(_ key: String, account: String) {
        self.key = key
        self.account = account
        /// Setting initial state for keychain
        _data = State(wrappedValue: KeyChainManager.shared.read(key: key, account: account))
    }
    
    private func setdata(_ newValue: Data?) -> Data {
        guard let newValue else {
            data = nil
            KeyChainManager.shared.delete(key: key, account: account)
            return .init()
        }
        return newValue
    }
}
