//
//  ExtensionDouble.swift
//  Ziyon
//
//  Created by Elioene Fernandes on 23/03/23.
//

import SwiftUI

public extension Double {
    
    // MARK: Extension To Convert Double To String With K,M Number Values
    // from 1K up to 100M
    var numberToString: String {
        if self >= 0 && self < 1_000 {
            return String(
                format: "0",
                locale: Locale.current,
                self / 0
            )
            .replacingOccurrences(of: ".0", with: "")
        }
        if self >= 1_000 && self < 999_999 {
            return String(
                format: "%.fK",
                locale: Locale.current,
                self / 1_000
            )
            .replacingOccurrences(of: ".0", with: "")
        }
        if self > 999_999 {
            return String(
                format: "%.fM",
                locale: Locale.current,
                self / 1_000_000
            )
            .replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%.0f", locale: Locale.current, self)
    }
    
    /// Rounds the double to decimal places value
    func removeZeros() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 2
        // maximum digits in Double after dot (maximum precision)
        formatter.maximumFractionDigits = 2
        return String(formatter.string(from: number) ?? "")
    }
    
    /// Create a localized currency string
    func asCurrency(_ currency: CurrencyType, withSymbol: Bool = true, maximumFractionDigits: Int = 3) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = currency.minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.currencySymbol = ""
        formatter.currencyGroupingSeparator = currency.thousandsSeparator
        formatter.currencyDecimalSeparator = currency.decimalSeparator
        formatter.negativePrefix = ""
        formatter.positivePrefix = ""
        
        guard var formattedAmount = formatter.string(from: self as NSNumber) else {
            return String(self)
        }
        
        if withSymbol {
            if currency.spaceBetweenAmountAndSymbol {
                formattedAmount = "\(currency.symbol) \(formattedAmount)"
            } else {
                formattedAmount = "\(currency.symbol)\(formattedAmount)"
            }
        }
        
        return "\(self < .zero ? "-" : "")\(formattedAmount)"
    }
    
    /// devides value by 12
    func perYear() -> Double {
        return self / 12.0
    }

    /// Converts a double Number into Percentage
    /// ```
    /// Convert 1.2345 to 1.23%
    /// ```
    func asPercentage()-> String {
        return String(format: "%.2f", self) + "%"
    }

}
#Preview(body: {
    Text(0.000472.asCurrency(.pound, maximumFractionDigits: 8))
})
