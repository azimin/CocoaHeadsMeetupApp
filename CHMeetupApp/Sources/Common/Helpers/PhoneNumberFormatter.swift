//
//  PhoneNumberFormatter.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 17/07/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

struct PhoneNumberFormatter {
  static func format(number: String) -> String {
    let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    var result = ""
    var index = cleanPhoneNumber.startIndex

    for character in Constants.TemplateTextMasks.phone.characters {
      if index == cleanPhoneNumber.endIndex { break }
      if character == Constants.TemplateTextMasks.replacementCharacter {
        result.append(cleanPhoneNumber[index])
        index = cleanPhoneNumber.index(after: index)
      } else {
        result.append(character)
      }
    }
    return result
  }
}
