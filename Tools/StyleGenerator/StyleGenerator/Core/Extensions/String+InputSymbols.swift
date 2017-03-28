//
//  String+InputSymbols.swift
//  StyleGenerator
//
//  Created by Denis on 25.03.17.
//  Copyright © 2017 DenRee. All rights reserved.
//

import Cocoa

extension String {

  enum InputSeparator: String {
    case dot = "."
    case space = " "
  }

  enum InputDetector: String {
    case varName = "$"
  }

  enum InputKey: String {
    case parentsAttribute = "parents"
  }

  func components(separatedBy separator: InputSeparator) -> [String] {
    return components(separatedBy: separator.rawValue)
  }

  func uniqueComponents(by symbol: InputSeparator) -> Set<String> {
    return Set(components(separatedBy: symbol))
  }

  func has(separator: InputSeparator) -> Bool {
    return components(separatedBy: separator).count > 1
  }
}
