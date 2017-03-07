//
//  InfoAboutLectureCell.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 28/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class SpeechDetailsTableViewCell: UITableViewCell {

  @IBOutlet var speechDetailsLabel: UILabel!

  func configure(with item: String) {
    speechDetailsLabel.text = item
  }
}

extension SpeechDetailsTableViewCell: ReusableCell {

  static var nib: UINib? {
    return UINib(nibName: String(describing: self), bundle: nil)
  }

  static var identifier: String {
    return String(describing: self)
  }
}
