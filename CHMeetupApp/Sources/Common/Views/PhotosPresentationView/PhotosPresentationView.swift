//
//  PhotosPresentationView.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 16/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

protocol PhotosPresentationViewDelegate: class {
  func photosPresentationViewWillUpdateData(view: PhotosPresentationView)
}

class PhotosPresentationView: UIView {

  weak var delegate: PhotosPresentationViewDelegate?

  var photos: [UIImage] = [] {
    didSet {
      drawPhotos()
      delegate?.photosPresentationViewWillUpdateData(view: self)
    }
  }

  open var borderColor: CGColor = UIColor.white.cgColor

  override func layoutSubviews() {
    super.layoutSubviews()

    drawPhotos()
  }

  private func drawPhotos() {
    for view in subviews {
      view.removeFromSuperview()
    }

    for (index, image) in photos.enumerated() {
      let viewHeight = bounds.height
      let viewWidth = bounds.width

      let xImageView = ((CGFloat(index) * viewHeight) * 0.8).round(0.5) // each new element takes 80% of view height
      let leadingEdgeSecondImageView = ((CGFloat(index + 1) * viewHeight) * 0.8) + viewHeight
      let borderWidth = viewHeight * Constants.SystemSizes.imageViewBorderWidthPercentage

      let imageView = UIImageView()
      imageView.backgroundColor = UIColor.white
      imageView.frame = CGRect(x: xImageView, y: 0.0, width: viewHeight, height: viewHeight)

      if (xImageView + viewHeight) <= viewWidth {
        imageView.image = image

        if leadingEdgeSecondImageView > viewWidth && photos.count > index {
          imageView.image = #imageLiteral(resourceName: "img_template_unknown")
        } else {
          imageView.roundWithBorder(borderWidth)
        }

        addSubview(imageView)
        sendSubview(toBack: imageView)
      } else { break }
    }
  }
}
