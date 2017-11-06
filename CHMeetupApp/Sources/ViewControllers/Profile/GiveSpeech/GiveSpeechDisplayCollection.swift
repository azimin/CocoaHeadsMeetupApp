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
  weak var delegate: ProfileHierarhyViewControllerType?

  var numberOfSections: Int {
    return sections.count
  }

  func numberOfRows(in section: Int) -> Int {
    return 1
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    let type = sections[indexPath.section]

    guard let viewController = delegate?.getViewController()
      as? GiveSpeechViewController else { fatalError("Subscribe to delegate") }

    let isEnabled = viewController.sentGiveSpeechId == nil
    // If we have giveSpeech waiting review
    if !isEnabled {
      let predicate = NSPredicate(format: "id == \(viewController.sentGiveSpeechId ?? 0)")
      let dataCollection = DataModelCollection(type: GiveSpeechEntity.self).filtered(predicate)
      // Guarantee that have minimum 1
      if dataCollection.count > 0 {
        nameText = dataCollection[0].title
        descriptionText = dataCollection[0].descriptionText
      }
    }
    switch type {
    case .name:
      return TextFieldPlateTableViewCellModel(value: nameText,
                                              placeholder: "Название".localized,
                                              textFieldDelegate: self,
                                              isEnabled: isEnabled,
                                              valueChanged: { [weak self] value in
                                                self?.nameText = value
      })
    case .description:
      return TextViewPlateTableViewCellModel(value: descriptionText,
                                             placeholder: "О чем будет Ваш доклад?".localized,
                                             isEnabled: isEnabled,
                                             textViewDelegate: self,
                                             delegate: self)
    }
  }

  func height(for indexPath: IndexPath) -> CGFloat {
    switch sections[indexPath.section] {
    case .name:
      return UITableViewAutomaticDimension
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

extension GiveSpeechDisplayCollection {
  var failedSection: Int? {
    if nameText.isEmpty {
      return 0
    }
    if descriptionText.isEmpty {
      return 1
    }
    return nil
  }
}
