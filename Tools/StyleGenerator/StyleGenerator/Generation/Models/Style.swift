//
//  Style.swift
//  StyleGenerator
//
//  Created by Denis on 25.03.17.
//  Copyright © 2017 DenRee. All rights reserved.
//

import Cocoa

// swiftlint:disable force_cast

typealias StyleName = String

// MARK: - Style

struct Style: TemplateModel {

  // MARK: - Properties

  let name: StyleName
  let parentsNames: [StyleName]?
  let attributes: [StyleAttribute]

  var allComponents: [String: Any] {
    var result = [String: Any]()
    for attribute in attributes {
      for component in attribute.components {
        switch attribute.type {
        case .default:
          result[attribute.name] = component.value
        case .complex:
          let separator = String.InputSymbols.dot.rawValue
          result[attribute.name + separator + component.key] = component.value
        }
      }
    }
    return result
  }

  // MARK: - Public

  init?(_ parameters: TemplateInputParameters) {
    guard parameters.keys.count == 1,
          let styleName = parameters.keys.first else {
      exit(with: "Wrong generation for style, it should be Dictionary with one Key == Style name - \(parameters)")
      return nil
    }

    guard let attributesParameters = parameters[styleName] as? [String: Any],
          attributesParameters.keys.count > 0 else {
      exit(with: "It should has at least 1 attribute and stored as [key: value]- \(parameters)")
      return nil
    }

    self.name = styleName

    /// Check if style has parents
    let parentsKey = String.InputKey.parentsAttribute.rawValue
    if let parentsNames = parameters[parentsKey] as? [String] {
      self.parentsNames = parentsNames
    } else {
      self.parentsNames = nil
    }

    //TODO: Need to improve realization of method
    var groupedParameters = [String: [String: Any]]()
    for parameter in attributesParameters {
      let firstComponent = parameter.key.components(separatedBy: .dot).first
      if let firstComponent = firstComponent {
        if var currentAttributes = groupedParameters[firstComponent] {
          currentAttributes[parameter.key] = parameter.value
          groupedParameters[firstComponent] = currentAttributes
        } else {
          groupedParameters[firstComponent] = [parameter.key: parameter.value]
        }
      } else {
        exit(with: "Name should be exist")
      }
    }

    var resultAttributes = [StyleAttribute]()
    for parameter in groupedParameters.enumerated() {
      let attribute = StyleAttribute(parameter.element.value)
      if let attribute = attribute {
        resultAttributes.append(attribute)
      } else {
        exit(with: "Something went wrong with attribute - \(parameter.element.key)")
      }
    }
    self.attributes = resultAttributes
  }
}

extension Style: Hashable {
  // MARK: - Hashable

  var hashValue: Int {
    return name.hashValue
  }

  static func == (lhs: Style, rhs: Style) -> Bool {
    return lhs.name.hashValue == rhs.name.hashValue
  }
}

extension Style {

  static func createAll(from parameters: TemplateInputParameters) -> Set<Style>? {

    // TODO: Need to improve realization of method
    guard let parameters = parameters as? [String: [String: Any]], parameters.count > 0 else {
      return nil
    }

    var result = Set<Style>()

    /// Use this method to create styles, if they doesn't exist
    /// And add them to `result`
    func createIfNeeded(_ styleNames: [String]) {

      for name in styleNames {
        /// Check if we need to create style
        let existedStyle = result.first(where: {$0.name == name})
        if existedStyle == nil {
          guard var styleParameters = parameters[name] else {
            exit(with: "Style should has parameters")
            return
          }

          var styleComponents = [String: Any]()
          let parentsKey = String.InputKey.parentsAttribute.rawValue

          /// Check if style has parents
          let parentsNames = styleParameters[parentsKey]
          if let parentsNames = parentsNames as? [String] {
            /// Create paretns if needed
            createIfNeeded(parentsNames)

            /// Get attributes from parents and update if they override each other
            let reversedParents = parentsNames.reversed()
            for parentName in reversedParents {
              if let parent = result.first(where: {$0.name == parentName}) {
                for component in parent.allComponents {
                  styleComponents.updateValue(component.value, forKey: component.key)
                }
              }
            }
          }

          styleParameters.removeValue(forKey: parentsKey)

          /// Setup own properties
          for parameter in styleParameters {
            styleComponents.updateValue(parameter.value, forKey: parameter.key)
          }
          if let style = Style([name: styleComponents]) {
            result.insert(style)
          }
        }
      }
    }

    //Run recursion
    var parametersNames = [String]()
    for parameter in parameters {
      parametersNames.append(parameter.key)
    }
    createIfNeeded(parametersNames)

    return result
  }
}
