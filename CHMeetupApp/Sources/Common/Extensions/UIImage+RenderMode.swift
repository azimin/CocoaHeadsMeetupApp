//
//  UIImage+RenderMode.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 08/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit.UIImage

extension UIImage {
  var imageWithTemplateRendingMode: UIImage {
    return self.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
  }
}
