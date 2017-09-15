//
//  Color.swift
//  StyleGenerator
//
//  Created by Denis on 10.03.17.
//  Copyright © 2017 DenRee. All rights reserved.
//

import Foundation

struct ColorsCollection: TemplateModel {

  // MARK: - Properties

  let colors: [Color]

  // MARK: - Public

  init?(_ parameters: TemplateInputParameters) {
    guard let colorsParameters = parameters["colors"] as? [TemplateInputParameters] else {
      exit(with: "you don't have parameteter 'colors'")
      return nil
    }
    colors = TemplateModelsFactory.makeModels(from: colorsParameters)
  }
}

struct Color: TemplateModel {

  // MARK: - Properties

  let name: String
  let hex: String

  // MARK: - Public

  init?(_ parameters: TemplateInputParameters) {
    guard let name = parameters["name"] as? String else {
      exit(with: "'Name' parameter for Color doesn't exist as String")
      return nil
    }

    guard let hex = parameters["color"] as? String else {
      exit(with: "'color' parameter for Color doesn't exist as String")
      return nil
    }

    self.name = name
    let hexSymbol = "#"
    self.hex = hex.hasPrefix(hexSymbol) ? hex : hexSymbol + hex
  }
}
