//
//  ReusableCell.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 09/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit.UINib

protocol ReusableCell {
  static var identifier: String { get }
  static var nib: UINib { get }
}
