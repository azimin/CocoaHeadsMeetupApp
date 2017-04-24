//
//  MainViewDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 24/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class MainViewDisplayCollection: DisplayCollection, DisplayCollectionAction {
  static var modelsForRegistration: [CellViewAnyModelType.Type] {
    return [EventPreviewTableViewCellModel.self, ActionTableViewCellModel.self]
  }

  private enum `Type` {
    case events
    case actionButtons
  }

  weak var delegate: DisplayCollectionWithTableViewDelegate?

  private var sections: [Type] = [.events, .actionButtons]
  private var actionPlainObjects: [ActionPlainObject] = []

  private var indexPath: IndexPath?

  let groupImageLoader = GroupImageLoader.standard

  func configureActionCellsSection(on viewController: UIViewController,
                                   with tableView: UITableView) {
    let actionCell = ActionCellConfigurationController()

    let action = {
      guard let index = self.indexPath else {
        return
      }
      self.actionPlainObjects.remove(at: index.row)
      tableView.deleteRows(at: [index], with: .left)
    }

    let notificationPermissionCell = actionCell.checkAccess(on: viewController,
                                                            for: .notifications,
                                                            with: {
                                                              PushNotificationController.configureNotification()
                                                              action()
    })

    if let notificationCell = notificationPermissionCell {
      actionPlainObjects.append(notificationCell)
    }
  }

  let modelCollection: DataModelCollection<EventEntity> = {
    let predicate = NSPredicate(format: "endDate > %@", NSDate())
    let modelCollection = DataModelCollection(type: EventEntity.self).filtered(predicate)
    return modelCollection.sorted(byKeyPath: #keyPath(EventEntity.endDate), ascending: false)
  }()

  var numberOfSections: Int {
    return sections.count
  }

  func numberOfRows(in section: Int) -> Int {
    switch sections[section] {
    case .events:
      return modelCollection.count
    case .actionButtons:
      return actionPlainObjects.count
    }
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    switch sections[indexPath.section] {
    case .events:
      return EventPreviewTableViewCellModel(event: modelCollection[indexPath.row],
                                            index: indexPath.row,
                                            delegate: self,
                                            groupImageLoader: groupImageLoader)
    case .actionButtons:
      return ActionTableViewCellModel(action: actionPlainObjects[indexPath.row])
    }
  }

  func didSelect(indexPath: IndexPath) {
    switch sections[indexPath.section] {
    case .events:
      let selectedId = modelCollection[indexPath.row].id
      delegate?.follow(destination: CommonDestination.eventPreview(id: selectedId))
    case .actionButtons:
      self.indexPath = indexPath
      actionPlainObjects[indexPath.row].action?()
    }
  }
}

extension MainViewDisplayCollection: EventPreviewTableViewCellDelegate {
  func eventCellAcceptButtonPressed(_ eventCell: EventPreviewTableViewCell) {
    guard let indexPath = delegate?.getIndexPath(from: eventCell) else {
      assertionFailure("IndexPath is unknown")
      return
    }
    let id = modelCollection[indexPath.row].id
    delegate?.follow(destination: CommonDestination.registrationPreview(id: id))
  }
}
