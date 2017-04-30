//
//  TemplateModelsFactory.swift
//  StyleGenerator
//
//  Created by Denis on 10.03.17.
//  Copyright © 2017 DenRee. All rights reserved.
//

import Foundation

// MARK: - Model

typealias CustomParameters = [String: Any]
typealias TemplateInputParameters = [String: Any]

protocol TemplateModel {
  init?(_ parameters: TemplateInputParameters)
}

// MARK: - Factory

final class TemplateModelsFactory {

  // MARK: - Public

  static func makeModels<ModelType: TemplateModel>(from parameters: [TemplateInputParameters]?) -> [ModelType] {
    guard let parameters = parameters else {
      print("parameters are empty")
      return []
    }
    var result = [ModelType]()
    for parameter in parameters {
      if let model = ModelType(parameter) {
        result.append(model)
      }
    }

    return result
  }
}
