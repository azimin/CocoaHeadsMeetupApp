//
//  InfoAboutLectureCell.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 28/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class InfoAboutLectureCell: UITableViewCell {

  @IBOutlet weak var infoAboutLectureLabel: UILabel!
  @IBOutlet weak var avatarLectureView: UIImageView!

  func configure(with: InfoAboutEvent, index: Int) {
    infoAboutLectureLabel.text = with.speechThemes[index - 2] + "\n" + with.namesOfLecture[index - 2]
  }

  static var nib: UINib {
    return UINib(nibName: String(describing: self), bundle: nil)
  }

  static var identifier: String {
    return String(describing: self)
  }

}
