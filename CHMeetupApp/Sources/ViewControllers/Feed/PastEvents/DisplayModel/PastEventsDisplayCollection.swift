//
//  PastEventsDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Denis on 03.03.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

final class PastEventsDisplayCollection: DisplayCollection, DisplayCollectionAction {
  static var modelsForRegistration: [CellViewAnyModelType.Type] {
    return [EventPreviewTableViewCellModel.self]
  }

  let modelCollection: DataModelCollection<EventEntity> = {
    let predicate = NSPredicate(format: "endDate < %@", NSDate())
    let modelCollection = DataModelCollection(type: EventEntity.self).filtered(predicate)
    return modelCollection.sorted(byKeyPath: #keyPath(EventEntity.endDate), ascending: false)
  }()

  weak var delegate: DisplayCollectionWithTableViewDelegate?

  let groupImageLoader = GroupImageLoader.standard

  var numberOfSections: Int {
    return 1
  }

  func numberOfRows(in section: Int) -> Int {
    return modelCollection.count
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    return EventPreviewTableViewCellModel(event: modelCollection[indexPath.row],
                                          index: indexPath.row,
                                          delegate: self,
                                          groupImageLoader: groupImageLoader)
  }

  func didSelect(indexPath: IndexPath) {
    let selectedId = modelCollection[indexPath.row].id
    delegate?.follow(destination: CommonDestination.eventPreview(id: selectedId))
  }
}

extension PastEventsDisplayCollection: EventPreviewTableViewCellDelegate {
  func eventCellAcceptButtonPressed(_ eventCell: EventPreviewTableViewCell) {
    guard let indexPath = delegate?.getIndexPath(from: eventCell) else {
      assertionFailure("IndexPath is unknown")
      return
    }
    let id = modelCollection[indexPath.row].id
    delegate?.follow(destination: CommonDestination.registrationPreview(id: id))
  }
}
