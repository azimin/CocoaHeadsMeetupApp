//
//  AboutSpeechTableViewCellModel.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 29/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

struct AboutSpeechTableViewCellModel {
  let speech: SpeechEntity
}

extension AboutSpeechTableViewCellModel: CellViewModelType {
  func setup(on cell: AboutSpeechTableViewCell) {
    cell.infoLabel.text = "О докладе:".localized
    cell.titleLabel.text = speech.title
    cell.descriptionLabel.text = speech.descriptionText
  }
}
