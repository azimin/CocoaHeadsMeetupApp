//
//  FormatterType.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 23/07/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

protocol FormatterType {
  var keyboardType: UIKeyboardType { get }
  func format(_ value: String) -> String?
}
