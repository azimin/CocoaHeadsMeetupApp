//
//  GiveSpeechDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 18/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class GiveSpeechDisplayCollection: NSObject, DisplayCollection {
  static var modelsForRegistration: [CellViewAnyModelType.Type] {
    return [TextFieldPlateTableViewCellModel.self, TextViewPlateTableViewCellModel.self]
  }

  enum `Type` {
    case name
    case description
  }

  var sections: [Type] = [
    .name,
    .description
  ]

  private(set) var nameText = ""
  fileprivate(set) var descriptionText = ""

  fileprivate(set) var textView: UITextView?

  var numberOfSections: Int {
    return sections.count
  }

  func numberOfRows(in section: Int) -> Int {
    return 1
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    let type = sections[indexPath.section]
    switch type {
    case .name:
      return TextFieldPlateTableViewCellModel(placeholder: "Название".localized,
                                              textFieldDelegate: self,
                                              valueChanged: { [weak self] value in
                                                self?.nameText = value
      })
    case .description:
      return TextViewPlateTableViewCellModel(placeholder: "О чем будет Ваша речь?".localized,
                                             textViewDelegate: self,
                                             delegate: self)
    }
  }

  func height(for indexPath: IndexPath) -> CGFloat {
    switch sections[indexPath.section] {
    case .name:
      return 52
    case .description:
      return 175
    }
  }

  func headerHeight(for section: Int) -> CGFloat {
    switch sections[section] {
    case .name, .description:
      return 40
    }
  }

  func headerTitle(for section: Int) -> String {
    switch sections[section] {
    case .name:
      return "Название доклада".localized
    case .description:
      return "Описание доклада".localized
    }
  }
}

extension GiveSpeechDisplayCollection: UITextViewDelegate, TextViewPlateTableViewCellModelDelegate {
  func textViewDidChange(_ textView: UITextView) {
    descriptionText = textView.text
  }

  func model(model: TextViewPlateTableViewCellModel, didLoadTextView textView: UITextView) {
    self.textView = textView
  }
}

extension GiveSpeechDisplayCollection: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let nameIndex = sections.index(of: .name),
      let descriptionIndex = sections.index(of: .description),
      nameIndex < descriptionIndex {
      textView?.becomeFirstResponder()
      return false
    }
    return true
  }
}
