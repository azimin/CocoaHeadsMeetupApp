//
//  OptionalValue.swift
//  CHMeetupApp
//
//  Created by Igor Voynov on 04.04.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

postfix operator <=

func <= <T>(left: inout T, right: T?) {
  if let value = right {
    left = value
  }
}

func <= <T>(left: inout T?, right: T?) {
  if let value = right {
    left = value
  }
}
