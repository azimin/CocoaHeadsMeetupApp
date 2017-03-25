//
//  PastEventsDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Denis on 03.03.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

protocol PastEventsDisplayCollectionDelegate: class {
  func shouldPresent(viewController: UIViewController)
}

struct PastEventsDisplayCollection: DisplayCollection, DisplayCollectionAction {
  static var modelsForRegistration: [CellViewAnyModelType.Type] {
    return [EventPreviewTableViewCellModel.self]
  }

  let modelCollection: DataModelCollection<EventEntity> = {
    let predicate = NSPredicate(format: "endDate < %@", NSDate())
    let modelCollection = DataModelCollection(type: EventEntity.self).filtered(predicate)
    return modelCollection
  }()

  weak var delegate: PastEventsDisplayCollectionDelegate?

  var numberOfSections: Int {
    return 1
  }

  func numberOfRows(in section: Int) -> Int {
    return modelCollection.count
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    return EventPreviewTableViewCellModel(event: modelCollection[indexPath.row], index: indexPath.row)
  }

  func didSelect(indexPath: IndexPath) {
    let eventPreview = Storyboards.EventPreview.instantiateEventPreviewViewController()
    delegate?.shouldPresent(viewController: eventPreview)
  }
}
