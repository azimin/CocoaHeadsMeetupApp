//
//  StyleGroup.swift
//  StyleGenerator
//
//  Created by Denis on 26.03.17.
//  Copyright © 2017 DenRee. All rights reserved.
//

import Cocoa

final class StyleGroup {

  var name: String
  var childs: Set<StyleGroup>?

  required init(_ name: String) {
    self.name = name
  }
}

extension StyleGroup: Hashable {
  // MARK: - Hashable

  var hashValue: Int {
    return name.hashValue
  }

  static func == (lhs: StyleGroup, rhs: StyleGroup) -> Bool {
    return lhs.name == rhs.name
  }
}

extension StyleGroup {

  /// Method to create styles group from parameters
  ///
  /// - Parameter parameters: Keys of dicrionary - equal name of styles (ex. "text.header")
  /// - Returns: Unique style groups
  static func createAll(from parameters: [String]) -> Set<StyleGroup>? {

    // TODO: Need to improve this method

    guard parameters.count > 0 else {
      return nil
    }

    var result = Set<StyleGroup>() /// Use this to create unique groups
    var allChilds = [String: [String]]() /// Use this to collect childs groups

    for parameter in parameters {

      /// Find components separated by `.`
      var components = parameter.components(separatedBy: .dot)

      /// Remove top style name
      let name = components.first ?? parameter
      components = Array(components.dropFirst())

      /// Check, if group was created
      let group = result.filter({ $0.name == name }).first
      if let group = group {

        /// If we have components, we add childs for grop
        var currentAllGroups = allChilds[group.name] ?? []
        if components.count > 0 {
          currentAllGroups.append(components.joined(separator: String.InputSymbols.dot.rawValue))
        }
        allChilds[group.name] = currentAllGroups
      } else {

        //Create new, if doesn't find
        let group = StyleGroup(name)
        if components.count > 0 {
          allChilds[group.name] = [components.joined(separator: String.InputSymbols.dot.rawValue)]
        } else {
          allChilds[group.name] = []
        }
        result.insert(group)
      }
    }

    /// When we collect childs for groups, now we can setup them with recursion
    for childGroups in allChilds {
      if let group = result.filter({ $0.name == childGroups.key }).first {
        group.childs = createAll(from: childGroups.value)
      }
    }
    return result
  }
}
