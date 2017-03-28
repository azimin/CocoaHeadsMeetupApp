//
//  CodeTemplate.swift
//  StyleGenerator
//
//  Created by Denis on 28.03.17.
//  Copyright © 2017 DenRee. All rights reserved.
//

import Cocoa

struct CodeTemplatesCollection: TemplateModel {

  // MARK: - Properties

  let templates: [CodeTemplate]

  // MARK: - Public

  init?(_ parameters: TemplateInputParameters) {
    guard let fontsParameters = parameters["code_templates"] as? [TemplateInputParameters] else {
      consoleController.printMessage("you don't have parameter 'code_templates'")
      return nil
    }
    templates = TemplateModelsFactory.makeModels(from: fontsParameters)
  }
}

struct CodeTemplate: TemplateModel {

  // MARK: - Properties

  let name: String
  let template: String

  // MARK: - Public

  init?(_ parameters: TemplateInputParameters) {
    guard parameters.count == 1 else {
      exit(with: "Template should be creted as 1 pair key-value object")
      return nil
    }

    guard let name = parameters.keys.first else {
      return nil
    }

    guard let template = parameters.values.first as? String else {
      exit(with: "Check your template")
      return nil
    }

    self.name = name
    self.template = template
  }
}
