//
//  UIImage+ColorImage.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 17/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

extension UIImage {
  static func from(color: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img!
  }
}
