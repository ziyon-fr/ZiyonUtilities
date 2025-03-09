//
//  ZiyonErrorProtocol.swift
//  Ziyon
//
//  Created by Elioene Silves Fernandes on 19/10/2023.
//

import SwiftUI

// MARK: Erase alers and erros to Procolos
public protocol ZiyonErrorProtocol {
    var title: String { get }
    var subtitle: String? { get }
    var actions: AnyView { get }
}
