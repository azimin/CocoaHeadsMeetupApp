//
//  PlateTableViewCellAppearance.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 12/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

@objc
class PlateTableViewCellAppearance: NSObject {
  let cornerRadius: CGFloat
  let horizontalMarginValue: CGFloat
  let verticalMarginValues: CGFloat
  let backgroundColor: UIColor
  let selectedBackgroundColor: UIColor

  init(cornerRadius: CGFloat,
       horizontalMarginValue: CGFloat,
       verticalMarginValues: CGFloat,
       backgroundColor: UIColor,
       selectedBackgroundColor: UIColor) {
    self.cornerRadius = cornerRadius
    self.horizontalMarginValue = horizontalMarginValue
    self.verticalMarginValues = verticalMarginValues
    self.backgroundColor = backgroundColor
    self.selectedBackgroundColor = selectedBackgroundColor
  }
}
