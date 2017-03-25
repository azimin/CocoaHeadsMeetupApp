//
//  StylesTemplate.swift
//  StyleGenerator
//
//  Created by Denis on 19.03.17.
//  Copyright © 2017 DenRee. All rights reserved.
//

import Cocoa

typealias StyleTemplateAttribute = String
typealias StyleTemplateGroup = (name: String, styles: [Style])

class StylesTemplate: GeneratedModelTemplate {

  // MARK: - Properties

  fileprivate let model: StylesCollection
  fileprivate let styleGroups: [StyleTemplateGroup]
  fileprivate let styleAttributes: [StyleTemplateAttribute]

  // MARK: - Public

  required init(_ model: StylesCollection) {
    self.model = model
    self.styleGroups = StylesTemplate.makeStyleGroups(from: model)
    self.styleAttributes = StylesTemplate.makeStyleAttributes(from: model)
  }

  func generate() throws -> TemplateOutputCode {
    var output = "/**\n"

    for group in styleGroups {
      output += StylesTemplate.generateGroupProtocol(for: group)
      output += .newLine
    }

    output += StylesTemplate.generateStylesEnum(for: styleGroups)
    output += .newLine
    output += StylesTemplate.generateStyleAttributes(for: styleAttributes)

    output += "\n*/"
    return TemplateOutputCode(output)
  }
}

// MARK: - Private

fileprivate extension StylesTemplate {

  // MARK: - Markdown

  static func generateGroupProtocol(for group: StyleTemplateGroup) -> String {
    var output = ""

    var nestedStyles: [String.CodeSymbols] = []
    for style in group.styles {
      let styleVarCode = "static var \(style.name.capitalFirst): Style { get }"
      nestedStyles.append(.line(string: styleVarCode))
    }
    let groupCodeTitle = styleProtocolName(for: group)
    let groupCode = String.CodeSymbols.snippet(type: .protocol, for: groupCodeTitle, nestedTypes: nestedStyles)

    output += groupCode
    return output
  }

  static func generateStylesEnum(for groups: [StyleTemplateGroup]) -> String {
    var output = ""

    var nestedStyleGroups: [String.CodeSymbols] = []
    for group in groups {
      let groupName = group.name.capitalFirst
      let enumName = groupName + ": " + styleProtocolName(for: group)
      let nestedGroupEnum = String.CodeSymbols.enum(name: enumName, cases: [])
      nestedStyleGroups.append(.newLine)
      nestedStyleGroups.append(.mark(title: groupName))
      nestedStyleGroups.append(nestedGroupEnum)
      nestedStyleGroups.append(.newLine)
    }

    output += String.CodeSymbols.snippet(type: .enum, for: "Styles: Resetable", nestedTypes: nestedStyleGroups)
    return output
  }

  static func generateStyleAttributes(for attributes: [StyleTemplateAttribute]) -> String {
    var output = ""

    var attributeCases = [EnumCase]()
    for attribute in attributes {
      attributeCases.append(EnumCase(attribute, caseValue: nil))
    }
    let attributeEnum = String.CodeSymbols.enum(name: "StyleAttributes: String", cases: attributeCases)
    let attributesExtension = String.CodeSymbols.snippet(type: .extension, for: "Styles", nestedTypes: [attributeEnum])

    output += attributesExtension
    return output
  }

  private static func styleProtocolName(for group: StyleTemplateGroup) -> String {
    return "\(group.name.capitalFirst)Style"
  }
}

fileprivate extension StylesTemplate {

  // MARK: - Factory

  static func makeStyleGroups(from model: StylesCollection) -> [StyleTemplateGroup] {
    var uniqueGroups = Set<String>()
    for style in model.styles {
      if let group = style.group {
        uniqueGroups.insert(group.lowercased())
      }
    }

    var result = [StyleTemplateGroup]()
    for group in uniqueGroups {
      var styles = model.styles.filter({ (style) -> Bool in
        return style.group == group
      })
      styles = styles.sorted(by: { $0.name < $1.name })
      result.append(StyleTemplateGroup(group, styles))
    }

    return Array(result).sorted(by: { $0.name < $1.name })
  }

  static func makeStyleAttributes(from model: StylesCollection) -> [String] {
    var uniqueAttributes = Set<String>()
    for style in model.styles {
      for property in style.properties {
        let attribute = property.key
        if !exclusionAttributes.contains(attribute) {
          uniqueAttributes.insert(attribute)
        }
      }
    }
    return Array(uniqueAttributes).sorted(by: { $0 < $1 })
  }

  static var exclusionAttributes: [StyleTemplateAttribute] {
    return [String.InputSymbols.styleParentsAttribute]
  }
}

//////////////////////////////////////////
///////////TEST TEMPLATE//////////////////
/**
 var output = ""

 output += .header
 output += .line(string: "import UIKit.UIFont")
 output += .newLine

 output += .mark(title: "Stylable")
 output += .snippet(type: .protocol, for: "StyleAttribute", nestedTypes: [])
 output += .newLine

 let associatedtypeLine = String.CodeSymbols.line(string: "associatedtype AttributeType: StyleAttribute")
 let tuneFunction = String.CodeSymbols.line(string: "func tune(with attributes: [AttributeType])")
 output += .snippet(type: .protocol, for: "Stylable", nestedTypes: [associatedtypeLine, tuneFunction])
 output += .newLine

 output += .mark(title: "Label Style")

 var labelStyleCases = [EnumCase]()
 labelStyleCases.append(EnumCase("font(UIFont.FontType, size: CGFloat)", nil))
 labelStyleCases.append(EnumCase("color(UIColor.Color)", nil))
 let labelStyleEnum = String.CodeSymbols.enum(name: "LabelStyleAttribute: Style", cases: labelStyleCases)
 output += labelStyleEnum
 output += .newLine

 output += .mark(title: "Stylable extensions")

 //Create func tune(with styles: [LabelStyle])
 let labelTuneFuncTitle = "func tune(with attributes: [LabelStyleAttribute])"
 var switchCases = [SwitchCase]()
 switchCases.append(SwitchCase("font(let name, let size)", "self.font = UIFont(name, size: size)"))
 switchCases.append(SwitchCase("color(let color)", "self.textColor = UIColor(colorType: color)"))
 let stylesSwitch = String.CodeSymbols.switch(value: "attribute", cases: switchCases)

 let forCycleTitle = "attribute in attributes"
 let forCycle = [String.CodeSymbols.forCycle(iteratorTitle: forCycleTitle, nestedTypes: [stylesSwitch])]
 let labelTuneFunc = String.CodeSymbols.function(title: labelTuneFuncTitle, body: forCycle)

 //Create extension
 let forTypeName = "UILabel: Stylable"
 let fontExtension = String.CodeSymbols.snippet(type: .extension, for: forTypeName, nestedTypes: [labelTuneFunc])

 output += fontExtension
 output += .newLine

 return output
*/
