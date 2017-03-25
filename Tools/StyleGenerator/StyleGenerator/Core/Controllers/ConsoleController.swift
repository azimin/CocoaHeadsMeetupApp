//
//  ConsoleController.swift
//  StyleGenerator
//
//  Created by Denis on 10.03.17.
//  Copyright © 2017 DenRee. All rights reserved.
//

import Foundation

// MARK: - Options

enum TemplateOption: String {
  case unknown
  case colors
  case fonts
  case styles
}

// MARK: - Input

struct ConsoleInputParameters {
  let option: TemplateOption
  let inputPath: String
  let outputPath: String
}

// MARK: - Console

class ConsoleController {

  // MARK: - Nested types

  enum MessageOutputType {
    case error
    case standard
  }

  enum InputError: DescribedError {
    case emptyPath
    case wrongFileFormat
    case wrongArgumentsFormat
    case wrongArgumentsCount

    var message: String {
      switch self {
      case .emptyPath:
        return "You entered empty path"
      case .wrongFileFormat:
        return "You entered wrong format for file"
      case .wrongArgumentsFormat:
        return "You entered wrong argument"
      case .wrongArgumentsCount:
        return "You entered wrong number of arguments"
      }
    }
  }

  enum CommandLineArgument: Int {
    case template = 1
    case inputPath
    case outputPath

    static let requiredCount = 4
  }

  // MARK: - Public

  func obtainInputParameters() throws -> ConsoleInputParameters {
    let arguments = CommandLine.arguments
    // TODO: Remove it after implemtenting styles
    if arguments.count == 1 {
      // swiftlint:disable:next line_length
      let jsonPath = "/Users/denis/Life/Projects/OpenSource/CocoaHeads/MeetupApp/Tools/StyleGenerator/StyleGenerator/Generation/Models/StylesInputParameters.json"
      // swiftlint:disable:next line_length
      let outputPath = "/Users/denis/Life/Projects/OpenSource/CocoaHeads/MeetupApp/Tools/StyleGenerator/StyleGenerator/Generation/Models/TemplateStyles.swift"
      return ConsoleInputParameters(option: .styles, inputPath: jsonPath, outputPath: outputPath)
    }

    guard arguments.count == CommandLineArgument.requiredCount else {
      throw InputError.wrongArgumentsCount
    }

    guard let option = TemplateOption(rawValue: argument(for: .template)) else {
      throw InputError.wrongArgumentsFormat
    }

    let jsonPath = argument(for: .inputPath)
    if jsonPath.isEmpty {
      throw InputError.emptyPath
    } else if !jsonPath.hasSuffix(".json") {
      throw InputError.wrongFileFormat
    }

    let outputPath = argument(for: .outputPath)
    if outputPath.isEmpty {
      throw InputError.emptyPath
    } else if !outputPath.hasSuffix(".swift") {
      throw InputError.wrongFileFormat
    }

    return ConsoleInputParameters(option: option, inputPath: jsonPath, outputPath: outputPath)
  }

  func printMessage(_ message: String, for outputType: MessageOutputType = .standard) {
    switch outputType {
    case .standard:
      print("\(message)")
    case .error:
      fputs("\(message)\n", stderr)
      print("Please, try again")
    }
  }

  // MARK: - Private

  func argument(for type: CommandLineArgument) -> String {
    let arguments = CommandLine.arguments
    guard arguments.count > type.rawValue else {
      return ""
    }
    return arguments[type.rawValue]
  }
}
