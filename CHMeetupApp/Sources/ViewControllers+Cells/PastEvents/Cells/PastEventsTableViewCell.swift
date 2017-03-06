//
//  PastEventsTableViewCell.swift
//  CHMeetupApp
//
//  Created by Denis on 26.02.17.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

protocol ReusableCell {
  static var identifier: String { get }
  static var nib: UINib? { get }
}

class PastEventsTableViewCell: UITableViewCell {
  @IBOutlet fileprivate var titleLabel: UILabel!
  @IBOutlet fileprivate var dateLabel: UILabel!
  @IBOutlet fileprivate var placeholderImageView: UIImageView!
}

extension PastEventsTableViewCell {
  func configure(with item: PastEventsDisplayCollection.Item) {
    titleLabel.text = item.title
    dateLabel.text = item.dateTitle
  }
}

extension PastEventsTableViewCell: ReusableCell {
  static var identifier: String {
    return String(describing: self)
  }
  static var nib: UINib? {
    return UINib(nibName: String(describing: self), bundle: nil)
  }
}
