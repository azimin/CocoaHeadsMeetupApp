//
//  UIImageView+ImageLoader.swift
//  CHMeetupApp
//
//  Created by Igor Voynov on 06.04.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

extension UIImageView {
  func loadImage(from url: URL,
                 loader: AnyImageLoader = KingfisherImageLoader.standard,
                 placeholder: UIImage? = nil,
                 progressBlock: ImageLoader.ProgressBlock? = nil,
                 completionHandler: ImageLoader.CompletionBlock? = nil
    ) {

    loader.load(into: self, from: url,
                placeholder: placeholder, progressBlock: progressBlock, completionHandler: completionHandler)
  }

  func cancelLoadImage(_ loader: AnyImageLoader = KingfisherImageLoader.standard) {
    loader.cancel(self)
  }
}
