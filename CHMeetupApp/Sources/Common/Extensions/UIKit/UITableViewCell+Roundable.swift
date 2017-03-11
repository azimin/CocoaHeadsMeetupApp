//
//  UITableViewCell+Roundable.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 11/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

protocol RoundableTableViewCell {
  var cornerRadius: CGFloat { get }
  var spacing: CGFloat { get }
  var roundingInsideSection: Bool { get }
}

extension RoundableTableViewCell {
  var cornerRadius: CGFloat {
    return 8.0
  }

  /**
   * If we want to round cells inside section
   * without dependence from position
   */

  var roundingInsideSection: Bool {
    return true
  }

  var spacing: CGFloat {
    return 5.0
  }

  var cornerColor: UIColor {
    return UIColor.gray
  }

}

class BackgroundView: UIView { }

extension UITableViewCell: RoundableTableViewCell {

  func drawCorner(in tableView: UITableView, indexPath: IndexPath) {

    // If already created layer for corner ignor
    if let selectedBackgroundView = self.selectedBackgroundView, selectedBackgroundView is BackgroundView {
      return
    }

    let shape: CAShapeLayer = CAShapeLayer()
    let selectionShape: CAShapeLayer = CAShapeLayer()

    let frameSpace = CGRect(x: self.spacing, y: 0,
                            width: self.frame.width - spacing * 2,
                            height: self.frame.height)

    var roundingCorners: UIRectCorner = []
    if roundingInsideSection {
      roundingCorners = .allCorners
    } else {

      /**
       * If Rows count in section less than 1
       * rounding all cell corners
       * else
       */

      let sectionRows = tableView.numberOfRows(inSection: indexPath.section)

      if sectionRows > 1 {
        if indexPath.row == 0 {
          roundingCorners = [.topLeft, .topRight]
        } else if indexPath.row == sectionRows - 1 {
          roundingCorners = [.bottomLeft, .bottomRight]
        }
      }

    }
    let path = UIBezierPath(roundedRect: frameSpace,
                            byRoundingCorners: roundingCorners,
                            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))

    shape.path = path.cgPath
    shape.fillColor = UIColor.clear.cgColor
    shape.strokeColor = cornerColor.cgColor

    selectionShape.path = path.cgPath
    selectionShape.fillColor = cornerColor.cgColor

    self.layer.addSublayer(shape)

    self.selectedBackgroundView = BackgroundView()
    self.selectedBackgroundView?.backgroundColor = UIColor.brown
    self.selectedBackgroundView?.layer.mask = selectionShape

    self.contentView.layoutMargins.left += spacing
    self.contentView.layoutMargins.right += spacing

  }

}
