//
//  StyleAttribute.swift
//  StyleGenerator
//
//  Created by Denis on 28.03.17.
//  Copyright © 2017 DenRee. All rights reserved.
//

import Cocoa

struct StyleAttribute: TemplateModel {

  enum `Type` {
    case `default`
    case `complex`
  }

  // MARK: - Private

  /// It's general name of attribute, 
  /// We have 2 types:
  /// 1. Default - textColor - here `name` == textColor
  /// 2. Complex - font.name - here `name` == name
  let name: String
  let components: [String: Any]
  let type: Type

  // MARK: - Public

  init?(_ parameters: TemplateInputParameters) {
    guard parameters.keys.count > 0 else {
      exit(with: "Style attributes should be creted more then 1 parameter")
      return nil
    }

    // Check if it's Default attribute (has name and parameter)
    guard parameters.count > 1 else {
      let nameKey = parameters.keys.first ?? ""
      self.name = nameKey
      self.components = parameters
      self.type = .default
      return
    }

    /// Check, if it's Complex attribute (few parameters belongs to 1 attribute)
    /// Use set for name to be sure that we has the same first component for name
    var attibuteName = Set<String>()
    for key in parameters.keys {
      if let firstComponent = key.components(separatedBy: .dot).first {
        attibuteName.insert(firstComponent)
      } else {
        exit(with: "Components should belongs 1 attribute")
      }
    }

    self.name = attibuteName.first!
    self.type = .complex
    var resultComponents = [String: Any]()
    for parameter in parameters {
      //Remove attribute name from component
      let attributeName = self.name + String.InputSeparator.dot.rawValue
      let componentKey = parameter.key.replacingOccurrences(of: attributeName, with: "")
      resultComponents[componentKey] = parameter.value
    }
    self.components = resultComponents
  }
}
