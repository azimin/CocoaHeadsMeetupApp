//
//  MainViewDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 24/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

struct MainViewDisplayCollection: DisplayCollection {
  static var modelsForRegistration: [CellViewAnyModelType.Type] {
    return [EventPreviewTableViewCellModel.self, ActionTableViewCellModel.self]
  }

  enum `Type` {
    case events
    case actionButtons
  }

  var sections: [Type] = [.events, .actionButtons]

  let modelCollection: DataModelCollection<EventEntity> = {
    let predicate = NSPredicate(format: "endDate > %@", NSDate())
    let modelCollection = DataModelCollection(type: EventEntity.self).filtered(predicate)
    return modelCollection
  }()

  var numberOfSections: Int {
    return 2
  }

  func numberOfRows(in section: Int) -> Int {
    switch sections[section] {
    case .events:
      return modelCollection.count
    case .actionButtons:
      return 1
    }
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    switch sections[indexPath.section] {
    case .events:
      return EventPreviewTableViewCellModel(event: modelCollection[indexPath.row], index: indexPath.row)
    case .actionButtons:
      let action = ActionPlainObject(text: "Example".localized, imageName: nil, action: nil)
      let model = ActionTableViewCellModel(action: action)
      return model
    }
  }
}
