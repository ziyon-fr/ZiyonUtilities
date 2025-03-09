//
//  CurrencyType.swift
//  Ziyon
//
//  Created by Wellington Nascente Hirsch on 31/07/23.
//

import Foundation
import SwiftUI

public enum CurrencyType: String, CaseIterable, Codable, Identifiable {
    
    public var id: Self { self }
    // Traditional
    /// Ex: ₴1.234,56
    case ziyon
    /// Ex: R$ 1.234,56
    case brazilian
    /// Ex: $1,234.56
    case dollar
    /// Ex: €1.234,56
    case euro
    /// Ex: £1,234.56
    case pound
    /// Ex: ₽ 1.234,56
    case ruble
    /// Ex: ¥ 1,234.56
    case yuan
    /// Ex: ₩ 1,234.56
    case won
    /// Ex: ¥ 1,234.56
    case yen
    
    // Crypto
    /// Ex: ₿1,234.56789876
    case bitcoin
    /// Ex: Ξ1,234.567898
    case ethereum
    /// Ex: ₮1,234.567
    case tether
    /// Ex: ❖1,234.567898
    case binance
    /// Ex: Ø1,234.567898
    case ion
    
   
}

public extension CurrencyType {
    
    static var supportedCurrency: [Self] {
        return [.brazilian, .euro, .dollar, .pound]
    }
    
    var isCrypto: Bool {
        self == .bitcoin || self == .ethereum || self == .tether || self == .binance
    }
    
    var name: String {
        switch self {
            // Traditional
        case .ziyon: return "ION"
        case .brazilian: return "BRL"
        case .dollar: return "USD"
        case .euro: return "EUR"
        case .pound: return "GBP"
        case .ruble: return "RUB"
        case .yuan: return "CNY"
        case .won: return "KRW"
        case .yen: return "JPY"
            // Crypto
        case .bitcoin: return "BTC"
        case .ethereum: return "ETH"
        case .tether: return "USDT"
        case .binance: return "BNB"
        case .ion: return "ION"
        }
    }
    
    var description: String {
        switch self {
            // Traditional
        case .ziyon: return "ZIYØN"
        case .brazilian: return "Real"
        case .dollar: return "Dólar"
        case .euro: return "Euro"
        case .pound: return "Libra"
        case .ruble: return "Rublo"
        case .yuan: return "Yuan"
        case .won: return "Won"
        case .yen: return "Yen"
            // Crypto
        case .bitcoin: return "Bitcoin"
        case .ethereum: return "Ethereum"
        case .tether: return "Tether"
        case .binance: return "Binance"
        case .ion: return "IØN"
        }
    }
    
    var symbol: String {
        switch self {
            // Traditional
        case .ziyon: return "₴"
        case .brazilian: return "R$"
        case .dollar: return "$"
        case .euro: return "€"
        case .pound: return "£"
        case .ruble: return "₽"
        case .yuan: return "¥"
        case .won: return "₩"
        case .yen: return "¥"
            // Crypto
        case .bitcoin: return "₿"
        case .ethereum: return "Ξ"
        case .tether: return "₮"
        case .binance: return "❖"
        case .ion: return "Ø"
        }
    }
    
    var icon: AssetIcon {
        switch self {
            // Traditional
        case .ziyon: return .coinZiyon
        case .brazilian: return .coinBrazilian
        case .dollar: return .coinDollar
        case .euro: return .coinEuro
        case .pound: return .coinPound
        case .ruble: return .coinRuble
        case .yuan: return .coinYuan
        case .won: return .coinWon
        case .yen: return .coinYen
            // Crypto
        case .bitcoin: return .coinBitcoin
        case .ethereum: return .coinEthereum
        case .tether: return .coinTether
        case .binance: return .coinBinance
        case .ion: return .coinZiyon
        }
    }
    
    var thousandsSeparator: String {
        switch self {
            // Traditional
        case .ziyon: return "."
        case .brazilian: return "."
        case .dollar: return ","
        case .euro: return "."
        case .pound: return ","
        case .ruble: return "."
        case .yuan: return ","
        case .won: return ","
        case .yen: return ","
            // Crypto
        case .bitcoin: return ","
        case .ethereum: return ","
        case .tether: return ","
        case .binance: return ","
        case .ion: return ","
        }
    }
    
    var decimalSeparator: String {
        switch self {
            // Traditional
        case .ziyon: return ","
        case .brazilian: return ","
        case .dollar: return "."
        case .euro: return ","
        case .pound: return "."
        case .ruble: return ","
        case .yuan: return "."
        case .won: return "."
        case .yen: return "."
            // Crypto
        case .bitcoin: return "."
        case .ethereum: return "."
        case .tether: return "."
        case .binance: return "."
        case .ion: return "."
        }
    }
    
    var spaceBetweenAmountAndSymbol: Bool {
        switch self {
            // Traditional
        case .ziyon: return false
        case .brazilian: return true
        case .dollar: return false
        case .euro: return false
        case .pound: return false
        case .ruble: return true
        case .yuan: return true
        case .won: return true
        case .yen: return true
            // Crypto
        case .bitcoin: return false
        case .ethereum: return false
        case .tether: return false
        case .binance: return false
        case .ion: return false
        }
    }
    
    var minimumFractionDigits: Int {
        switch self {
            // Traditional
        case .ziyon: return 2
        case .brazilian: return 2
        case .dollar: return 2
        case .euro: return 2
        case .pound: return 2
        case .ruble: return 2
        case .yuan: return 2
        case .won: return 2
        case .yen: return 2
            // Crypto
        case .bitcoin: return 0
        case .ethereum: return 0
        case .tether: return 0
        case .binance: return 0
        case .ion: return 0
        }
    }
    
    var maximumFractionDigits: Int {
        switch self {
            // Traditional
        case .ziyon: return 2
        case .brazilian: return 2
        case .dollar: return 2
        case .euro: return 2
        case .pound: return 2
        case .ruble: return 2
        case .yuan: return 2
        case .won: return 2
        case .yen: return 2
            // Crypto
        case .bitcoin: return 8
        case .ethereum: return 6
        case .tether: return 3
        case .binance: return 6
        case .ion: return 6
        }
    }
    
}


#Preview {
    Text(CurrencyType.supportedCurrency[0].name)
        .format()
}

