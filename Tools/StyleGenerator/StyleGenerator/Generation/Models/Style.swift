//
//  Style.swift
//  StyleGenerator
//
//  Created by Denis on 25.03.17.
//  Copyright © 2017 DenRee. All rights reserved.
//

import Cocoa

typealias StyleProperties = [String: Any]

// swiftlint:disable force_cast

struct StylesCollection: TemplateModel {

  // MARK: - Properties

  let styles: [Style]

  // MARK: - Public

  init?(_ parameters: TemplateInputParameters) {
    guard let stylesParameters = parameters["styles"] as? [TemplateInputParameters] else {
      exit(with: "You don't have parameter 'styles' - \(parameters)")
      return nil
    }
    self.styles = TemplateModelsFactory.makeModels(from: stylesParameters)
  }
}

struct Style: TemplateModel {

  // MARK: - Properties

  let name: String
  let group: String?
  var properties = StyleProperties()

  // MARK: - Public

  init?(_ parameters: TemplateInputParameters) {
    guard parameters.keys.count == 1,
          let styleName = parameters.keys.first else {
      exit(with: "Wrong generation for style, it should be Dictionary with one Key == Style name")
      return nil
    }

    guard let styleProperties = parameters[styleName] as? StyleProperties,
          styleProperties.keys.count > 0 else {
      exit(with: "Wrong generation for style, it should has at least 1 property and stored as key: value")
      return nil
    }

    let nameComponents = styleName.components(separatedBy: String.InputSymbols.styleNameSeparator)
    let count = nameComponents.count

    if count == 0 || count > 2 {
      self.group = nil
      self.name = ""
      exit(with: "Wrong generation for style, it should be Dictionary with one Key == Style name")
      return nil
    } else if count == 1 {
      self.group = nil
      self.name = nameComponents[0]
    } else {
      self.group = nameComponents[0]
      self.name = nameComponents[1]
    }
    properties = styleProperties
  }
}
