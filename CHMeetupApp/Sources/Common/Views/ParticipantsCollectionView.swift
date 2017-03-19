//
//  ParticipantCollection.swift
//  CHMeetupApp
//
//  Created by Dima on 16/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class ParticipantsCollectionView: UIView {

  var imagesCollection: [UIImage] = [] {
    didSet {
      drawParticipants()
    }
  }

  var borderColor: CGColor {
    get {
      return UIColor.white.cgColor
    }
    set {
      self.borderColor = newValue
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    drawParticipants()
  }

  private func drawParticipants() {
    for view in self.subviews {
      view.removeFromSuperview()
    }

    for (index, image) in imagesCollection.enumerated() {
      let viewHeight = self.bounds.height
      let viewWidth = self.bounds.width

      let xImageView = ((CGFloat(index) * viewHeight) * 0.8).round(0.5) // each new element takes 80% of view height
      let leadingEdgeSecondImageView = ((CGFloat(index + 1) * viewHeight) * 0.8) + viewHeight

      let imageView = UIImageView()
      imageView.clipsToBounds = true
      imageView.contentMode = .scaleAspectFill
      imageView.layer.cornerRadius = viewHeight / 2 // cornerRadius = 50% of view height
      imageView.frame = CGRect(x: xImageView, y: 0.0, width: viewHeight, height: viewHeight)

      let border = CAShapeLayer()
      border.frame = imageView.bounds
      border.lineWidth = (viewHeight * 0.1).round(0.5) //borderWidth = 5% of view height x2
      border.path = UIBezierPath(ovalIn: border.bounds).cgPath
      border.strokeColor = UIColor.white.cgColor
      border.fillColor = UIColor.clear.cgColor
      imageView.layer.addSublayer(border)

      if (xImageView + viewHeight) <= viewWidth {
        imageView.image = image

        if leadingEdgeSecondImageView > viewWidth && imagesCollection.count > index {
          border.strokeColor = UIColor.clear.cgColor
          imageView.image = #imageLiteral(resourceName: "img_template_unknown")
        }

        self.addSubview(imageView)
        self.sendSubview(toBack: imageView)
      } else { break }
    }
  }
}
