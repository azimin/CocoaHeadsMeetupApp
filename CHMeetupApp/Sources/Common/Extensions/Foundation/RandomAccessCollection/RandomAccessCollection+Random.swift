//
//  RandomAccessCollection+Random.swift
//  CHMeetupApp
//
//  Created by Igor Voynov on 04.04.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

extension RandomAccessCollection {
  var rand: Iterator.Element? {
    guard count > 0 else { return nil }
    let offset = arc4random_uniform(numericCast(count))
    return self[index(startIndex, offsetBy: numericCast(offset))]
  }
}
