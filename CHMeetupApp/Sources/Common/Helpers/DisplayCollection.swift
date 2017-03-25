//
//  DisplayCollection.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 10/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

protocol DisplayCollection {
  var numberOfSections: Int { get }
  static var modelsForRegistration: [CellViewAnyModelType.Type] { get }

  func numberOfRows(in section: Int) -> Int
  func model(for indexPath: IndexPath) -> CellViewAnyModelType
}

protocol DisplayCollectionAction {
  func didSelect(indexPath: IndexPath)
}

extension DisplayCollection {
  var numberOfSections: Int {
    return 1
  }
}
