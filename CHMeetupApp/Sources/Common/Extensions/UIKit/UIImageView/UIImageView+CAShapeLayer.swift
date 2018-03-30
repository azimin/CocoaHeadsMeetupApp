//
//  UIImageView+CAShapeLayer.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 01/05/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit.UIImageView
import ObjectiveC

private var associationKey = "cashapelayer_border"

// MARK: - CAShapeLayer
extension UIImageView {
  var shapeLayerBorder: CAShapeLayer? {
    get {
      return objc_getAssociatedObject(self, &associationKey) as? CAShapeLayer
    }
    set {
      objc_setAssociatedObject(self, &associationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
  }
}
