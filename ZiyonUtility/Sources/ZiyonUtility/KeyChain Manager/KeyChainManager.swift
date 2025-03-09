//
//  KeyChainManager.swift
//  Ziyon
//
//  Created by Elioene Silves Fernandes on 07/02/2024.
//

import SwiftUI

/// Key Chain class Helper
class KeyChainManager {
    
    /// Access class data
    static let shared = KeyChainManager()
    
    
    private func generateDataQuery(
        data: Data,
        for key: String,
        account: String
    ) -> CFDictionary {
        
        let query = [
            kSecValueData: data,
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        return query
    }
    
    private func updateData(data: Data, for key: String, account: String) {
        /// Updating Data
        let updatedQuery = generateDataQuery(data: data, for: key, account: account)
        /// Update Filed
        let updateAttributes = [kSecValueData : data] as CFDictionary
        
        SecItemUpdate(updatedQuery, updateAttributes)
        
    }
    //MARK:
    /// Saving keychain Values
    func save(data: Data, for key: String, account: String) {
        /// Creating data Query
        let query = generateDataQuery(data: data, for: key, account: account)
        
        /// Adding data to KeyChain
        let status = SecItemAdd(query, nil)
        /// verifying status
        
        switch status {
            /// Case Success
        case errSecSuccess : print("Success Saving Data")
            /// Updating data
        case errSecDuplicateItem : updateData(data: data, for: key, account: account)
            
        default:
            print("From: \(Self.self) - Error", status.description)
        }
        
    }
    // MARK:
    /// Reading data
    func read(key: String, account: String) -> Data? {
        let query = [
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var resultData: AnyObject?
        
        SecItemCopyMatching(query, &resultData)
        
        return (resultData as? Data)
        
    }
    
    // MARK:
    /// deleting Key Chain Data
    func delete(key: String, account: String) {
        
        let query = [
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary
        
        SecItemDelete(query)
    }
   
}
