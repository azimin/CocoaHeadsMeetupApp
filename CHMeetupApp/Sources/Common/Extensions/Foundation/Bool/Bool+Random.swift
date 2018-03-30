//
//  Bool+Random.swift
//  CHMeetupApp
//
//  Created by Igor Voynov on 04.04.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

extension Bool {
  static var rand: Bool {
    return (0...1).rand == 0 ? false : true
  }
}
