//
//  ColorsTemplate.swift
//  StyleGenerator
//
//  Created by Denis on 19.03.17.
//  Copyright © 2017 DenRee. All rights reserved.
//

import Cocoa

class ColorsTemplate: GeneratedModelTemplate {

  // MARK: - Properties

  fileprivate var model: ColorsCollection

  // MARK: - Public

  required init(_ model: ColorsCollection) {
    self.model = model
  }

  func generate() throws -> TemplateOutputCode {
    guard model.colors.count > 0 else {
      throw TemplateError.wrongData(option: .colors)
    }

    var output = ""

    output += .header
    output += .line(string: "import UIKit.UIColor")
    output += .newLine
    output += .mark(title: "Pallete")

    // Create ColorType enum
    let colorEnumCases = model.colors.flatMap({ EnumCase($0.name, "\"\($0.hex)\"") })
    let colorEnum = String.CodeSymbols.enum(name: "ColorType", cases: colorEnumCases)

    // Create init func
    let initFuncTitle = "convenience init(_ colorType: ColorType)"
    let initFuncBody = String.CodeSymbols.line(string: "self.init(hexString: colorType.rawValue)")
    let initFunc = String.CodeSymbols.function(title: initFuncTitle, body: [initFuncBody])

    // Create extension
    let nestedTypes = [
      colorEnum,
      .newLine,
      initFunc
    ]
    let colorExtension = String.CodeSymbols.snippet(type: .extension, for: "UIColor", nestedSymbols: nestedTypes)
    output += colorExtension

    return output
  }
}
