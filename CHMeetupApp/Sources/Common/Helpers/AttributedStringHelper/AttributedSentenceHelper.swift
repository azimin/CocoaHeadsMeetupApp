//
//  AttributedSentenceHelper.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 05.04.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class AttributedSentenceHelper {

  enum Preposition: String {
    case at

    var localizedValue: String {
      switch self {
      case .at:
        return "в".localized
      }
    }

    func concatString(firstPartString: String?, secondPartString: String?)
      -> NSAttributedString {
        let firstString = firstPartString ?? ""
        let secondString = secondPartString ?? ""
        let mainAttributes = [NSForegroundColorAttributeName: UIColor(.darkGray)]

        if !firstString.isEmpty && !secondString.isEmpty {
          let result = NSMutableAttributedString()
          let firstAttributedString = NSAttributedString(string: firstString, attributes: mainAttributes)
          result.append(firstAttributedString)

          let prepositionAttributes = [NSForegroundColorAttributeName: UIColor(.gray)]
          let prepositionAttributedString = NSAttributedString(string: " " + self.localizedValue + " ",
                                                               attributes: prepositionAttributes)
          result.append(prepositionAttributedString)

          let secondAttributedString = NSAttributedString(string: secondString, attributes: mainAttributes)
          result.append(secondAttributedString)
          return result
        } else {
          let string = firstString.isEmpty ? secondString : firstString
          return NSAttributedString(string: string, attributes: mainAttributes)
        }
    }
  }

}
