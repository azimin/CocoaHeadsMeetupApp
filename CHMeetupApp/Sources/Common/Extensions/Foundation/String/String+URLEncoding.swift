//
//  String+URLEncoding.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 04/05/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation
extension String {
  var urlEncoding: String {
    let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)

    if let escapedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
      return escapedString
    }

    return self
  }
}
