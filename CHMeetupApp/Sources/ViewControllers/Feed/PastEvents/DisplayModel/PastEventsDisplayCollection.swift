//
//  PastEventsDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Denis on 03.03.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

struct PastEventsDisplayCollection: DisplayCollection, DisplayCollectionAction, Templatable {
  static var modelsForRegistration: [CellViewAnyModelType.Type] {
    return [EventPreviewTableViewCellModel.self]
  }

  let modelCollection: DataModelCollection<EventEntity> = {
    let predicate = NSPredicate(format: "endDate < %@", NSDate())
    let modelCollection = DataModelCollection(type: EventEntity.self).filtered(predicate)
    return modelCollection
  }()

  var isTemplate: Bool = {
    return mainRealm.objects(EventEntity.self).isEmpty
  }()

  let templateModelCollection: [EventEntity] = {
    let templateModelCollection = Array(repeating: EventEntity.templateEntity, count: 5)
    return templateModelCollection
  }()

  weak var delegate: DisplayCollectionDelegate?

  let groupImageLoader = GroupImageLoader.standard

  var numberOfSections: Int {
    return 1
  }

  func numberOfRows(in section: Int) -> Int {
    return isTemplate ? templateModelCollection.count : modelCollection.count
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    let event = isTemplate ? templateModelCollection[indexPath.row] : modelCollection[indexPath.row]
    return EventPreviewTableViewCellModel(event: event,
                                          index: indexPath.row,
                                          groupImageLoader: groupImageLoader,
                                          isTemplate: isTemplate)
  }

  func didSelect(indexPath: IndexPath) {
    if !isTemplate {
      let eventPreview = Storyboards.EventPreview.instantiateEventPreviewViewController()
      eventPreview.selectedEventId = modelCollection[indexPath.row].id
      delegate?.push(viewController: eventPreview)
    }
  }
}
