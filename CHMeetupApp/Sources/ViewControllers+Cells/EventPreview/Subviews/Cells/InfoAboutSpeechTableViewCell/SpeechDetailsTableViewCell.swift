//
//  InfoAboutLectureCell.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 28/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class SpeechDetailsTableViewCell: UITableViewCell, ReusableCell {

  @IBOutlet var speechDetailsLabel: UILabel!

  func configure(with item: EventPreviewPO) {
    speechDetailsLabel.text = item.speechDetails
  }
  static var nib: UINib? {
    return UINib(nibName: String(describing: self), bundle: nil)
  }

  static var identifier: String {
    return String(describing: self)
  }

}
