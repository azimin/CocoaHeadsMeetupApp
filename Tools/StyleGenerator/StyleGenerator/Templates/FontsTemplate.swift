//
//  FontsTemplate.swift
//  StyleGenerator
//
//  Created by Denis on 19.03.17.
//  Copyright © 2017 DenRee. All rights reserved.
//

import Cocoa

class FontsTemplate: GeneratedModelTemplate {

  // MARK: - Properties

  fileprivate var model: FontsCollection

  // MARK: - Public

  required init(_ model: FontsCollection) {
    self.model = model
  }

  func generate() throws -> TemplateOutputCode {
    guard model.fonts.count > 0 else {
      throw TemplateError.wrongData(option: .fonts)
    }

    var output = ""

    output += .header
    output += .line(string: "import UIKit.UIFont")
    output += .newLine

    // Create FontType enum
    let enumCases = model.fonts.flatMap({ EnumCase("\($0.name)", "\"\($0.font)\"") })
    let fontEnum = String.CodeSymbols.enum(name: "FontType: String", cases: enumCases)

    // Create convenience init(_ fontType: FontType, size: CGFloat)
    let initFuncTitle = "convenience init(_ fontType: FontType, size: CGFloat)"
    let initFuncBody = String.CodeSymbols.line(string: "self.init(name: fontType.rawValue, size: size)!")
    let initFunc = String.CodeSymbols.function(title: initFuncTitle, body: [initFuncBody])

    // Create extension
    let nestedTypes = [
      fontEnum,
      .newLine,
      initFunc
    ]
    let fontExtension = String.CodeSymbols.snippet(type: .extension, for: "UIFont", nestedSymbols: nestedTypes)
    output += fontExtension

    return output
  }
}
