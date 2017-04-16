//
//  Int+Random.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 17/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

extension Int {
  static func random(lower: Int, upper: Int) -> Int {
    return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
  }
}
