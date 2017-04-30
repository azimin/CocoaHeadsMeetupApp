//
//  TemplateGenerator.swift
//  TemplateGenerator
//
//  Created by Denis on 10.03.17.
//  Copyright © 2017 DenRee. All rights reserved.
//

import Foundation

// MARK: - Models

typealias TemplateOutputCode = String

enum TemplateError: DescribedError {
  case wrongData(option: TemplateOption)

  var message: String {
    switch self {
    case let .wrongData(option):
      return "It looks like json for \(option) is wrong"
    }
  }
}

protocol GeneratedTemplate {
  func generate() throws -> TemplateOutputCode
}

protocol GeneratedModelTemplate: GeneratedTemplate {
  associatedtype TemplateModel
  init(_ model: TemplateModel)
}

// MARK: - Generator

class TemplateGenerator {

  // MARK: - Public

  func generateFiles(for parameters: ConsoleInputParameters) {
    do {
      let templateParameters = try FileController.readTemplateParameters(from: parameters.inputPath)
      let template = makeTemplate(for: parameters.option, with: templateParameters)
      let code = try template?.generate()
      if let code = code {
        try FileController.write(code: code, in:  parameters.outputPath)
      } else {
        exit(with: "Something went wrong")
      }
    } catch {
      exit(with: error)
    }
  }

  // MARK: - Private

  // swiftlint:disable:next line_length
  private func makeTemplate(for option: TemplateOption, with parameters: TemplateInputParameters?) -> GeneratedTemplate? {
    guard let parameters = parameters else { return nil }
    var result: GeneratedTemplate?

    switch option {
    case .unknown: break
    case .colors:
      if let colors = ColorsCollection(parameters) {
        result = ColorsTemplate(colors)
      }
    case .fonts:
      if let fonts = FontsCollection(parameters) {
        result = FontsTemplate(fonts)
      }
    case .styles:
       result = makeStylesTemplate(from: parameters)
    }

    return result
  }

  private func makeStylesTemplate(from parameters: TemplateInputParameters) -> StylesTemplate? {
    guard let stylesParameters = parameters["styles"] as? TemplateInputParameters else {
      exit(with: "You don't have parameter 'styles' - \(parameters)")
      return nil
    }

    guard let styleGroups = StyleGroup.createAll(from: Array(stylesParameters.keys)) else {
      exit(with: "You should have at least one 'styles group' - \(stylesParameters)")
      return nil
    }

    guard let styles = Style.createAll(from: stylesParameters) else {
      exit(with: "You should have at least one 'styles group' - \(stylesParameters)")
      return nil
    }
    var templates = [CodeTemplate]()
    if let templatesCollection = CodeTemplatesCollection(parameters) {
      templates = templatesCollection.templates
    }

    let model = StylesTemplateModel(styleGroups: Array(styleGroups), styles: Array(styles), codeTemplates: templates)
    return StylesTemplate(model)
  }
}
