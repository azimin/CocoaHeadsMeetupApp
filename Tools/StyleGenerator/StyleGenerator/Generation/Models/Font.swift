//
//  Font.swift
//  StyleGenerator
//
//  Created by Denis on 19.03.17.
//  Copyright © 2017 DenRee. All rights reserved.
//

import Cocoa

// swiftlint:disable force_cast

struct FontsCollection: TemplateModel {

  // MARK: - Properties

  let fonts: [Font]

  // MARK: - Public

  init?(_ parameters: TemplateInputParameters) {
    guard let fontsParameters = parameters["fonts"] as? [TemplateInputParameters] else {
      exit(with: "you don't have parameter 'fonts'")
      return nil
    }
    fonts = TemplateModelsFactory.makeModels(from: fontsParameters)
  }
}

struct Font: TemplateModel {

  // MARK: - Properties
  let name: String
  let font: String

  // MARK: - Public

  init?(_ parameters: TemplateInputParameters) {
    guard let fontName = parameters["fontName"] as? String else {
      exit(with: "'fontName' parameter for Font doesn't exist as String")
      return nil
    }

    font = fontName
    if let nameParams = parameters["name"] as? String {
      name = nameParams
    } else {
      name = type(of: self).generateName(from: font)
    }
  }
}

extension Font {

  // MARK: - Private

  // Convert from "GothamPro-Light" try -> "light", else "gothamPro"
  static func generateName(from fontName: String) -> String {
    if fontName.isEmpty {
      return ""
    }

    let fontComponents = fontName.components(separatedBy: .dash)

    if fontComponents.count > 1 {
      return fontComponents.last?.lowercased() ?? ""
    } else {
      let firstChar = String(fontName.characters.prefix(1)).lowercased()
      let remainChars = String(fontName.characters.dropFirst()).replacingOccurrences(of: "-", with: "")
      return firstChar + remainChars
    }
  }
}
