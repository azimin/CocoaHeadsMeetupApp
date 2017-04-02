//
//  String+InputSymbols.swift
//  StyleGenerator
//
//  Created by Denis on 25.03.17.
//  Copyright © 2017 DenRee. All rights reserved.
//

import Cocoa

extension String {

  enum InputSymbols: String {
    case dot = "."
    case space = " "
    case dash = "-"
    case componentDetector = "$"
  }

  enum InputKey: String {
    case parentsAttribute = "parents"
  }

  func components(separatedBy separator: InputSymbols) -> [String] {
    return components(separatedBy: separator.rawValue)
  }

  func uniqueComponents(by symbol: InputSymbols) -> Set<String> {
    return Set(components(separatedBy: symbol))
  }

  func has(separator: InputSymbols) -> Bool {
    return components(separatedBy: separator).count > 1
  }
}
