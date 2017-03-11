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

  let modelCollection = DataModelCollection(type: EventEntity.self)
  weak var delegate: PastEventsDisplayCollectionDelegate?

  var numberOfSections: Int {
    return modelCollection.count
  }

  func numberOfRows(in section: Int) -> Int {
    return 1
  }
  
  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    let model = EventPreviewTableViewCellModel(event: modelCollection[indexPath.section])
    return model
  }

  func didSelect(indexPath: IndexPath) {
    let eventPreview = Storyboards.EventPreview.instantiateEventPreviewViewController()
    delegate?.shouldPresent(viewController: eventPreview)
  }
}
