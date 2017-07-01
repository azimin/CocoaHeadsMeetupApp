//
//  CreatorDetailDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Andrey Konstantinov on 01/07/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

final class CreatorDetailDisplayCollection: DisplayCollection {

  enum `Type` {
    case header
    case info
  }

  var creator: CreatorEntity?

  weak var delegate: DisplayCollectionDelegate?

  private let sections: [Type] = [.header, .info]

  static var modelsForRegistration: [CellViewAnyModelType.Type] {
    return [CreatorHeaderTableViewCellModel.self, CreatorInfoTableViewCellModel.self]
  }

  var numberOfSections: Int {
    return sections.count
  }

  func numberOfRows(in section: Int) -> Int {
    switch sections[section] {
    case .header, .info:
      return 1
    }
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    guard let creator = creator else {
      fatalError("Creator should be set before using it")
    }
    switch sections[indexPath.section] {
    case .header:
      return CreatorHeaderTableViewCellModel(creator: creator)
    case .info:
      return CreatorInfoTableViewCellModel(creator: creator)
    }
  }

  func didSelect(indexPath: IndexPath) {
    switch sections[indexPath.section] {
    case .header:
      guard let urlString = creator?.url, let url = URL(string: urlString) else { return }
      delegate?.open(url: url)
    case .info:
      break
    }
  }
}
