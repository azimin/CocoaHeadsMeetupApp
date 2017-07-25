//
//  PhoneNumberFormatter.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 17/07/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class PhoneNumberFormatter: FormatterType {
  var keyboardType: UIKeyboardType = .phonePad

  func format(_ value: String) -> String? {
    var cleanPhoneNumber = value.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    var result = ""
    var index = cleanPhoneNumber.startIndex

    if cleanPhoneNumber.characters.count == 1 && cleanPhoneNumber.characters.first == "9" {
      cleanPhoneNumber = "79"
    }

    if cleanPhoneNumber.characters.first != "7", index != cleanPhoneNumber.endIndex {
        cleanPhoneNumber.replaceSubrange(index...index, with: "7")
    }

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
