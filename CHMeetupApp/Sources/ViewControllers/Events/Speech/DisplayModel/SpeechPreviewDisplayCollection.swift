//
//  SpeechPreviewDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 30.03.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import SafariServices

class SpeechPreviewDisplayCollection: DisplayCollection {

  enum `Type` {
    case speaker
    case speech
    case contentCells
  }

  var speech: SpeechEntity?

  weak var delegate: DisplayCollectionDelegate?

  var sections: [Type] = [.speaker, .speech, .contentCells]

  static var modelsForRegistration: [CellViewAnyModelType.Type] {
    return [SpeakerTableViewCellModel.self, AboutSpeechTableViewCellModel.self, ActionTableViewCellModel.self]
  }

  var numberOfSections: Int {
    return sections.count
  }

  func numberOfRows(in section: Int) -> Int {
    switch sections[section] {
    case .speaker, .speech:
      return 1
    case .contentCells:
      return speech?.contents.count ?? 0
    }
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    guard let speech = speech, let user = speech.user else {
      fatalError("Speech should be set before using it")
    }
    let type = sections[indexPath.section]
    switch type {
    case .speaker:
      return SpeakerTableViewCellModel(speaker: user)
    case .speech:
      return AboutSpeechTableViewCellModel(speech: speech)
    case .contentCells:
      let actionPlainObject = ActionPlainObject(text: speech.contents[indexPath.row].title,
                                                imageName: nil, action: { /* to do smth */ })
      return ActionTableViewCellModel(action: actionPlainObject)
    }
  }

  func didSelect(indexPath: IndexPath) {
    guard let speech = speech else {
      fatalError("Speech should be set before using it")
    }
    let type = sections[indexPath.section]
    switch type {
    case .contentCells:
      if let url = URL(string: speech.contents[indexPath.row].linkURL) {
        let safari = SFSafariViewController(url: url, entersReaderIfAvailable: true)
        delegate?.present(viewController: safari)
      }
    case .speaker, .speech:
      break
    }
  }
}
