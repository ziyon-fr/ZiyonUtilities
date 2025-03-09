//
//  ZiyonDatabaseError.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 20/08/23.
//

import SwiftUI

/// Enum representing various database errors that can occur during data operations.
public enum ZiyonDatabaseError: Error {
    /// The request is in a bad format.
    case badRequest
    
    /// The data couldn't be written because it isn't in the correct format.
    case badFormat
    
    /// Unauthorized access to the resource.
    case unauthorized
    
    /// Access to the resource is forbidden.
    case forbidden
    
    /// The requested data resource was not found.
    case dataNotFound
    
    /// Internal server error occurred.
    case serverError
    
    /// Request timeout due to slow or no internet connection.
    case timeout
    
    /// No internet connection available.
    case noInternetConnection
    
    /// Same data input
    case sameData
    
    /// An unexpected error occurred.
    case unexpected(code: Int)
    
    /// A custom error with a user-defined message.
    case custom(message: String)
}

extension ZiyonDatabaseError {
    /// Returns a Boolean value indicating whether the error is fatal.
    ///
    /// An unexpected error is considered fatal.
    var isFatal: Bool {
        if case ZiyonDatabaseError.unexpected = self { return true }
        else { return false }
    }
}

extension ZiyonDatabaseError: LocalizedError {
    /// A localized message corresponding to the error type.
    public var errorDescription: String? {
        switch self {
        case .badRequest:
            return NSLocalizedString("Bad request. Please check your input.", comment: "Bad request")
        case .badFormat:
            return NSLocalizedString("The data couldn’t be written \nbecause it isn’t in the correct format.", comment: "unauthorized")
        case .unauthorized:
            return NSLocalizedString("Unauthorized. You do not have permission to access this resource.", comment: "Bad request")
        case .forbidden:
            return NSLocalizedString("Forbidden. Access to this resource is forbidden.", comment: "forbidden")
        case .dataNotFound:
            return NSLocalizedString("Data resource not found.", comment: "notFound")
        case .serverError:
            return NSLocalizedString("Internal server error. Please try again later.", comment: "serverError")
        case .timeout:
            return NSLocalizedString("Request timeout. Please check your internet connection.", comment: "timeout")
        case .noInternetConnection:
            return NSLocalizedString(
                "No internet connection. Please connect to the internet and try again.",
                comment: "noInternetConnection"
            )
        case .unexpected(_):
            return NSLocalizedString("Bad request. Please check your input.", comment: "unexpected")
        case .custom(let message):
            return NSLocalizedString(message, comment: "custom Error")
        case .sameData:
            return NSLocalizedString("Same data Found when saving", comment: "sameData")
        }
    }
}

