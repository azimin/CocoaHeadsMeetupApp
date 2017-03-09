//
//  ImageCollectionViewCell.swift
//  CHMeetupApp
//
//  Created by Michael Galperin on 03.03.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import Photos

class ImageCollectionViewCell: UICollectionViewCell {

  let imageView = PhotosHelper.configuredImageView
  var requestID: PHImageRequestID?

  override func prepareForReuse() {
    super.prepareForReuse()
    if let imageRequestID = requestID {
      PHImageManager.default().cancelImageRequest(imageRequestID)
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(imageView)
    imageView.anchorToAllSides(of: self)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
