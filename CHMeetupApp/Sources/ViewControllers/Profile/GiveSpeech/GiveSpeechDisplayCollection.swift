//
//  GiveSpeechDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 18/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class GiveSpeechDisplayCollection: NSObject, DisplayCollection {
  enum `Type` {
    case textField
    case textView
  }

  var sections: [Type] = [.textField,
                          .textView]

  private(set) var nameText = ""
  fileprivate(set) var descriptionText = ""

  private var textView: UITextView?

  var numberOfSections: Int {
    return sections.count
  }

  func numberOfRows(in section: Int) -> Int {
    return 1
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    let type = sections[indexPath.section]
    switch type {
    case .textField:
      return TextFieldPlateTableViewCellModel(placeholder: "Название".localized) { [weak self] value in
        self?.nameText = value
      }
    case .textView:
      return TextViewPlateTableViewCellModel(placeholder: "О чем будет Ваша речь?".localized,
                                             textViewDelegate: self) { [weak self] textView in
        // For future purpose
        self?.textView = textView
      }
    }
  }

  func height(for indexPath: IndexPath) -> CGFloat {
    switch sections[indexPath.section] {
    case .textField:
      return 52
    case .textView:
      return 350
    }
  }

  func headerHeight(for section: Int) -> CGFloat {
    switch sections[section] {
    case .textField, .textView:
      return 40
    }
  }
}

extension GiveSpeechDisplayCollection: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    descriptionText = textView.text
  }
}
