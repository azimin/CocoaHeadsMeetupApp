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
}

class StylesTemplate: GeneratedModelTemplate {

  // MARK: - Properties
  fileprivate let model: StylesTemplateModel

  // MARK: - Public

  required init(_ model: StylesTemplateModel) {
    self.model = model
  }

  func generate() throws -> TemplateOutputCode {
    var output = "/**\n"

    for group in model.styleGroups {
      if let _ = group.childs {
        output += StylesTemplate.generateGroupProtocol(for: group)
        output += .newLine
      } else {
        output += StylesTemplate.generateStyleExtension(for: group.name)
        output += .newLine
      }
    }

    for group in model.styleGroups {
      if let _ = group.childs {
        output += StylesTemplate.generateStylesEnum(for: group)
        output += .newLine
      } else {
        output += StylesTemplate.generateStyleProperty(for: group.name)
        output += .newLine
      }
    }
    output += StylesTemplate.generateStyleAttributes(for: model.styles)

    output += "\n*/"
    return TemplateOutputCode(output)
  }
}

// MARK: - Private

fileprivate extension StylesTemplate {

  // MARK: - Generate Protocols

  static func generateGroupProtocol(for group: StyleGroup) -> String {
    guard let childs = group.childs else {
      return ""
    }
    var output = ""

    var nestedStyles: [String.CodeSymbols] = []
    for style in childs {
      var styleVarCode = ""
      let styleName = style.name.capitalFirst
      if let _ = style.childs {
        styleVarCode = "static var \(styleName): \(styleProtocolName(for: style)) { get }"
      } else {
        styleVarCode = "static var \(styleName): Style { get }"
      }
      nestedStyles.append(.line(string: styleVarCode))
    }
    let groupCodeTitle = styleProtocolName(for: group)
    let groupCode = String.CodeSymbols.snippet(type: .protocol, for: groupCodeTitle, nestedSymbols: nestedStyles)

    output += groupCode
    output += .newLine

    for style in childs {
      if let _ = style.childs {
        output += generateGroupProtocol(for: style)
      }
    }

    return output
  }

  static func generateStyleExtension(for styleName: StyleName) -> String {
    var output = ""

    var nestedStyles: [String.CodeSymbols] = []
    let styleVarCode = "static var \(styleName.capitalFirst): Style { get }"
    nestedStyles.append(.line(string: styleVarCode))
    let groupCode = String.CodeSymbols.snippet(type: .extension, for: "Style", nestedSymbols: nestedStyles)

    output += groupCode
    return output
  }

  // MARK: - Generate Style enum

  static func generateStylesEnum(for group: StyleGroup) -> String {
    guard let childs = group.childs else {
      return ""
    }

    var output = ""
    var nestedStyleGroups: [String.CodeSymbols] = []

    func generateEnum(for group: StyleGroup) -> String {
      var output = ""
      let groupName = group.name.capitalFirst
      let enumName = groupName + ": " + styleProtocolName(for: group)

      var nestedChilds: [String.CodeSymbols] = []
      if let childs = group.childs {
        for child in childs {
          if let _ = child.childs {
            nestedChilds.append(.line(string: generateEnum(for: child)))
          }
        }
      }

      let nestedGroupEnum = String.CodeSymbols.snippet(type: .enum, for: enumName, nestedSymbols: nestedChilds)
      output += .newLine
      output += .mark(title: groupName)
      output += nestedGroupEnum

      return output
    }

    nestedStyleGroups.append(.line(string: generateEnum(for: group)))
    output += String.CodeSymbols.snippet(type: .enum, for: "Styles: Resetable", nestedSymbols: nestedStyleGroups)
    return output
  }

  static func generateStyleProperty(for styleName: String) -> String {
    var output = ""

    var nestedStyleGroups: [String.CodeSymbols] = []
    let enumName = styleName.capitalFirst + ": " + "\(styleName.capitalFirst)Style"
    let nestedGroupEnum = String.CodeSymbols.enum(name: enumName, cases: [])
    nestedStyleGroups.append(.newLine)
    nestedStyleGroups.append(.mark(title: styleName.capitalFirst))
    nestedStyleGroups.append(nestedGroupEnum)
    nestedStyleGroups.append(.newLine)
    output += String.CodeSymbols.snippet(type: .extension, for: "Styles", nestedSymbols: nestedStyleGroups)

    return output
  }

  // MARK: - Generate Style Attributes

  static func generateStyleAttributes(for styles: [Style]) -> String {
    var output = ""

    var attributeCases = [EnumCase]()
    var attributes = Set<String>()
    for style in styles {
      for styleAttribute in style.attributes {
        attributes.insert(styleAttribute.name)
      }
    }

    for attribute in attributes {
      attributeCases.append(EnumCase(attribute, caseValue: nil))
    }
    let attributeEnum = String.CodeSymbols.enum(name: "StyleAttributes: String", cases: attributeCases)
    let attributesExtension = String.CodeSymbols.snippet(type: .extension, for: "Styles", nestedSymbols
      : [attributeEnum])

    output += attributesExtension
    return output
  }

  private static func styleProtocolName(for group: StyleGroup) -> String {
    return "\(group.name.capitalFirst)Style"
  }
}
