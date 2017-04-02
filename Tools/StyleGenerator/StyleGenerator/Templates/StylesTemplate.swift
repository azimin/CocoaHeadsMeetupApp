//
//  StylesTemplate.swift
//  StyleGenerator
//
//  Created by Denis on 19.03.17.
//  Copyright © 2017 DenRee. All rights reserved.
//

import Cocoa

struct StylesTemplateModel {
  let styleGroups: [StyleGroup]
  let styles: [Style]
  let codeTemplates: [CodeTemplate]
}

class StylesTemplate: GeneratedModelTemplate {

  // MARK: - Properties
  fileprivate let model: StylesTemplateModel

  // MARK: - Public

  required init(_ model: StylesTemplateModel) {
    self.model = model
  }

  func generate() throws -> TemplateOutputCode {
    var output = ""

    output += .header
    output += .line(string: "import UIKit")
    output += .newLine

    output += generateStylesEnum()
    output += generateStyleResetableExtension()
    output += generateStyleAttributes()
    output += generateStylesImplementation()

    output += ""
    return TemplateOutputCode(output)
  }
}

// MARK: - Private

fileprivate extension StylesTemplate {

  func generateStylesEnum() -> String {

    /// Recursive nested enums generation

    func generateNestedEnum(for group: StyleGroup) -> String {
      var output = ""

      let groupName = group.generatedName
      /// Check if group has childs, run nested enum generation for them
      if let childs = group.childs, childs.count > 0 {
        var nestedGroupChilds: [String.CodeSymbols] = []
        for child in childs {
          nestedGroupChilds.append(.line(string: generateNestedEnum(for: child)))
        }
        let groupEnum = String.CodeSymbols.snippet(type: .enum, for: "\(groupName)", nestedSymbols: nestedGroupChilds)
        output += groupEnum
      } else {

        /// Create style property, only if we reach the last component
        let stylePropertyName = "static var \(groupName): Style"
        let stylePropertyBody: String.CodeSymbols = .line(string: "return get_\(groupName)()")
        let styleProperty = String.CodeSymbols.property(fullName: stylePropertyName, nestedSymbols: [stylePropertyBody])
        output += styleProperty
      }

      return output
    }

    /// Run recursion

    var output = ""
    var nestedStyleGroups: [String.CodeSymbols] = []

    for group in model.styleGroups {
      nestedStyleGroups.append(.line(string: generateNestedEnum(for: group)))
    }
    output += String.CodeSymbols.snippet(type: .enum, for: "Styles", nestedSymbols: nestedStyleGroups)

    return output
  }

  func generateStyleResetableExtension() -> String {

    func generateStaticProperty(for group: StyleGroup, parentName: String) -> String {
      var output = ""
      let dot = String.InputSymbols.dot.rawValue

      if let childs = group.childs {
        for child in childs {
          let childProperty = generateStaticProperty(for: child, parentName: parentName + dot + group.name.capitalFirst)
          output += .line(string: childProperty)
        }
      } else {
        output += (parentName + dot + "_\(group.name.capitalFirst) = nil")
      }

      return output
    }

    var output = ""

    var resetFuncBody: [String.CodeSymbols] = []
    for group in model.styleGroups {
      resetFuncBody.append(.line(string: generateStaticProperty(for: group, parentName: "Styles")))
    }

    var nestedStyleGroups: [String.CodeSymbols] = []
    nestedStyleGroups.append(.function(title: "static func reset()", body: resetFuncBody))

    output += String.CodeSymbols.snippet(type: .extension, for: "Styles: Resetable", nestedSymbols: nestedStyleGroups)

    return output
  }

  // MARK: - Generate Style Attributes

  func generateStyleAttributes() -> String {
    var output = ""

    /// Collect unique attributes
    var attributes = Set<String>()
    for style in model.styles {
      for styleAttribute in style.attributes {
        attributes.insert(styleAttribute.name)
      }
    }

    /// Create attribute enum cases
    var attributeCases = [EnumCase]()
    for attribute in attributes {
      attributeCases.append(EnumCase(attribute, caseValue: nil))
    }
    let attributeEnum = String.CodeSymbols.enum(name: "Attributes: String", cases: attributeCases)
    let attributesExtension = String.CodeSymbols.snippet(type: .struct, for: "Style", nestedSymbols
      : [attributeEnum, .line(string: "var properties: [Attributes: Any]")])

    output += attributesExtension
    return output
  }

  // MARK: - Generate static properties

  func generateStylesImplementation() -> String {

    let dot = String.InputSymbols.dot.rawValue

    /// Run generation

    var output = ""

    var resultExtensions = [String: [Style]]()
    for group in model.styleGroups {
      let groupExtensions = generateStyleExtensions(for: group)
      for groupExtension in groupExtensions {
        resultExtensions[groupExtension.key] = groupExtension.value
      }
    }

    for groupExtension in resultExtensions {

      var nestedStyles: [String.CodeSymbols] = []
      for style in groupExtension.value {
        nestedStyles.append(contentsOf: generateStaticProperty(for: style))
      }

      let keyComponents = groupExtension.key.components(separatedBy: .dot).map({$0.capitalFirst})
      let extensionName = keyComponents.joined(separator: dot)
      let codeExtension = String.CodeSymbols.snippet(type: .extension, for: extensionName, nestedSymbols: nestedStyles)
      output += codeExtension
    }

    return output
  }

  /// Recursive generation for style's extensions
  private func generateStyleExtensions(for group: StyleGroup, with parent: String? = nil) -> [String: [Style]] {

    let dot = String.InputSymbols.dot.rawValue

    var fullName = ""
    var extensionName = "Styles"

    if let parent = parent {
      fullName = parent + dot + group.name
      extensionName += (dot + fullName)
    } else {
      fullName = group.name
      if let _ = group.childs {
        extensionName += (dot + fullName)
      }
    }

    var result = [String: [Style]]()
    if let childs = group.childs, childs.count > 0 {
      for child in childs {
        // Start recursion only if grop childs has childs
        if let _ = child.childs {
          let childResults = generateStyleExtensions(for: child, with: group.name)
          for childResult in childResults {
            result[childResult.key] = childResult.value
          }
        } else {
          let style = model.styles.first(where: { (style) -> Bool in
            return style.name == fullName + dot + child.name
          })
          if let style = style {
            var currentResult = result[extensionName] ?? []
            currentResult.append(style)
            result[extensionName] = currentResult
          }
        }
      }
    } else {
      let style = model.styles.first(where: { (style) -> Bool in
        return style.name == fullName
      })
      if let style = style {
        var currentResult = result[extensionName] ?? []
        currentResult.append(style)
        result[extensionName] = currentResult
      }
    }
    return result
  }

  private func generateStaticProperty(for style: Style) -> [String.CodeSymbols] {
    var result: [String.CodeSymbols] = []
    let varName = (style.name.components(separatedBy: .dot).last ?? "").capitalFirst

    var styleImplBody: [String.CodeSymbols] = []
    styleImplBody.append(.line(string: "if _\(varName) == nil {"))
    styleImplBody.append(.line(string: generateAttributesProperty(for: style).addIndentation()))

    let varInitialization = "_\(varName) = Style(properties: properties)".addIndentation()
    styleImplBody.append(.line(string: varInitialization))
    styleImplBody.append(.line(string: "}"))
    styleImplBody.append(.line(string: "return _\(varName)"))

    let styleImplTitle = "fileprivate static func get_\(varName)() -> Style"
    let styleImpl = String.CodeSymbols.function(title: styleImplTitle, body: styleImplBody)

    result.append(.line(string: "fileprivate static var _\(varName): Style!"))
    result.append(styleImpl)
    return result
  }

  private func generateAttributesProperty(for style: Style) -> String {
    var output = ""
    output += .line(string: "let properties: [Style.Attributes: Any] = [")
    for attribute in style.attributes {
      if attribute.name != String.InputKey.parentsAttribute.rawValue {
        var propertyComponent = generatePropertyComponent(from: attribute)
        if attribute != style.attributes.last! {
          propertyComponent += ","
        }
        output += .line(string: propertyComponent.addIndentation())
      }
    }
    output += .line(string: "]")
    return output
  }

  // TODO: Need to improve the code
  private func generatePropertyComponent(from attribute: StyleAttribute) -> String {
    var output = ""

    let attributeTemplate = model.codeTemplates.first { (template) -> Bool in
      return template.name == attribute.name
    }

    /// If property has template, create it with it
    if let attributeTemplate = attributeTemplate {
      output += generate(attribute, with: attributeTemplate)
    } else {
      output += generate(attribute, with: model.styles)
    }
    return output
  }

  private func generate(_ attribute: StyleAttribute, with template: CodeTemplate) -> String {
    var output = ""
    let detector = String.InputSymbols.componentDetector
    let attributeTemplate = template.template
    let components = attribute.components
    let name = attribute.name

    /// Check if template and attribute has same number of components
    let templateComponents = attributeTemplate.components(separatedBy: .componentDetector).count - 1
    guard templateComponents == components.count else { return output }

    /// If we have 1 component - we use only detector $
    if components.count == 1 {
      let relpacedString = detector.rawValue
      let newString = Array(components.values).first ?? ""
      let attributeValue = attributeTemplate.replacingOccurrences(of: relpacedString, with: "\(newString)")
      output += ".\(name): \(attributeValue)"
    } else {
      var attributeValue = attributeTemplate
      for component in components {
        let relpacedString = detector.rawValue + "\(component.key)"
        attributeValue = attributeValue.replacingOccurrences(of: relpacedString, with: "\(component.value)")
      }
      output += ".\(name): \(attributeValue)"
    }
    return output
  }

  func generate(_ attribute: StyleAttribute, with styles: [Style]) -> String {
    guard attribute.type == .default else {
      consoleController.printMessage("Attention: You try to create compex attribute without template")
      return ""
    }

    /// Check if value style, return Style format, else return value
    func styleValueIfNeeded(for value: String) -> String {

      /// Try to find style
      let componentStyle = model.styles.first(where: { (style) -> Bool in
        return style.name == value
      })

      guard let style = componentStyle else { return value }
      return "Styles.\(style.generatedName)"
    }

    var output = ""

    for component in attribute.components {
      output += ".\(component.key): \(styleValueIfNeeded(for: "\(component.value)"))"
    }
    return output
  }
}

// MARK: - Models

/// Use these extensions to generate Styles

fileprivate extension StyleGroup {
  var generatedName: String {
    return name.capitalFirst
  }
}

fileprivate extension Style {

  private var dot: String.InputSymbols {
    return .dot
  }

  /// Return the name of property - ex. Styles.Text.Title
  var generatedName: String {
    let nameComponents = name.components(separatedBy: dot).map({$0.capitalFirst})
    return nameComponents.joined(separator: dot.rawValue)
  }

  /// Return the name of property - ex. Styles.Text._Title
  var generatedStaticPropertyName: String {
    var nameComponents = name.components(separatedBy: dot).map({$0.capitalFirst})
    var lastComponent = nameComponents.popLast()!
    lastComponent = "_\(lastComponent.capitalFirst)"
    nameComponents.append(lastComponent)
    nameComponents.insert("Styles", at: 0)
    return nameComponents.joined(separator: dot.rawValue)
  }
}
