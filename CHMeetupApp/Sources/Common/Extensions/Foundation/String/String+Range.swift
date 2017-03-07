//
//  String+Range.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 08/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

extension String {
  func substring(from index: Int) -> String {
    return self.substring(from: self.characters.index(self.startIndex, offsetBy: index))
  }

  func substring(with range: Range<Int>) -> String {
    let startIndex = self.characters.index(self.startIndex, offsetBy: range.lowerBound)
    let endIndex = self.characters.index(self.startIndex, offsetBy: range.upperBound)
    return self.substring(with: startIndex..<endIndex)
  }
}
