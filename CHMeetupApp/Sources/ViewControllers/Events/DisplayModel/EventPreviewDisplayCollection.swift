//
//  GiveSpeechDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 21/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

protocol EventPreviewDisplayCollectionDelegate: class {
  func displayCollectionRequestingUIUpdate()
}

class EventPreviewDisplayCollection: DisplayCollection {
  static var modelsForRegistration: [CellViewAnyModelType.Type] {
    return [ActionTableViewCellModel.self, TimePlaceTableViewCellModel.self, SpeechPreviewTableViewCellModel.self]
  }

  var event: EventEntity? {
    didSet {
      setNeedsReloadData()
    }
  }

  weak var delegate: EventPreviewDisplayCollectionDelegate?

  // MARK: - Reload with cache engine

  func setNeedsReloadData() {
    guard isReloadDataInProgress == false else {
      return
    }

    isReloadDataInProgress = true
    OperationQueue.main.addOperation { [weak self] in
      self?.reloadData()
      self?.isReloadDataInProgress = false
    }
  }

  private var isReloadDataInProgress = false

  private func reloadData() {
    updateSections()
    delegate?.displayCollectionRequestingUIUpdate()
  }

  // MARK: - Sections

  enum `Type` {
    case location
    case adress
    case speaches
    case description
    case additionalCells
  }

  var sections: [Type] = []

  func updateSections() {
    sections = []

    // We always show location cell, but sometimes it's template
    sections.append(.location)

    // We show adress cell only if place exist
    if event?.place != nil {
      sections.append(.adress)
    }

    // We always show speaches and description cell, but sometimes it's template
    sections.append(.speaches)
    sections.append(.description)

    // We show additional cells only if event exist
    if event != nil {
      sections.append(.additionalCells)
    }
  }

  var numberOfSections: Int {
    return sections.count
  }

  func numberOfRows(in section: Int) -> Int {
    switch sections[section] {
    case .location, .adress, .description:
      return 1
    case .speaches:
      return 4
    case .additionalCells:
      return 2
    }
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    let type = sections[indexPath.section]
    switch type {
    case .location:
      return ActionTableViewCellModel(action: ActionPlainObject(text: "Test", imageName: nil, action: {}))
    case .adress:
      return ActionTableViewCellModel(action: ActionPlainObject(text: "Test", imageName: nil, action: {}))
    case .speaches:
      return ActionTableViewCellModel(action: ActionPlainObject(text: "Test", imageName: nil, action: {}))
    case .description:
      return SpeechPreviewTableViewCellModel(firstName: "Alex",
                                             lastName: "Zimin",
                                             userPhoto: Data(),
                                             topic: "How to please Kirill",
                                             speachDescription: "Read his CV")
    case .additionalCells:
      return ActionTableViewCellModel(action: ActionPlainObject(text: "Test", imageName: nil, action: { }))
    }
  }

  func didSelect(indexPath: IndexPath) {

  }
}
