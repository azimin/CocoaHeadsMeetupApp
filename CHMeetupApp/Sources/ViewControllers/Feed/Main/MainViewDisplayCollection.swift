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
    case collectionIsEmpty
  }

  weak var delegate: DisplayCollectionWithTableViewDelegate?

  private var sections: [Type] = [.events, .actionButtons, .collectionIsEmpty]
  private var actionPlainObjects: [ActionPlainObject] = []

  let groupImageLoader = GroupImageLoader.standard

  func updateActionCellsSection(on viewController: UIViewController,
                                with tableView: UITableView) {
    actionPlainObjects = []
    let actionCell = ActionCellConfigurationController()

    let action = { [weak self] in
      self?.delegate?.updateUI()
    }

    let notificationPermissionCell = actionCell.checkAccess(on: viewController,
                                                            for: .notifications,
                                                            with: {
                                                              action()
    })

    if let notificationCell = notificationPermissionCell {
      actionPlainObjects.append(notificationCell)
    }
  }

  var modelCollection: TemplateModelCollection<EventEntity> = {
    let predicate = NSPredicate(format: "endDate > %@", NSDate())
    var dataCollection = DataModelCollection(type: EventEntity.self).filtered(predicate)
    dataCollection = dataCollection.sorted(byKeyPath: #keyPath(EventEntity.endDate), ascending: false)
    return TemplateModelCollection(dataCollection: dataCollection)
  }()

  init() {
    modelCollection.delegate = self
  }

  var numberOfSections: Int {
    return sections.count
  }

  func numberOfRows(in section: Int) -> Int {
    switch sections[section] {
    case .events:
      return modelCollection.count
    case .actionButtons:
      return actionPlainObjects.count
    case .collectionIsEmpty:
      if modelCollection.count == 0 && actionPlainObjects.count == 0 {
        return 1
      }
      return 0
    }
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    switch sections[indexPath.section] {
    case .events:
      return EventPreviewTableViewCellModel(entity: modelCollection[indexPath.row],
                                            index: indexPath.row,
                                            delegate: self,
                                            groupImageLoader: groupImageLoader)
    case .actionButtons:
      return ActionTableViewCellModel(action: actionPlainObjects[indexPath.row])
    case .collectionIsEmpty:
      return ActionTableViewCellModel(action: ActionPlainObject(text:
        "Будущие события скоро появятся, и вы будете первыми, кто про это узнает!".localized
      ))
    }
  }

  func didSelect(indexPath: IndexPath) {
    switch sections[indexPath.section] {
    case .events:
      if modelCollection[indexPath.row].isTemplate {
        break
      }
      let eventPreview = Storyboards.EventPreview.instantiateEventPreviewViewController()
      eventPreview.selectedEventId = modelCollection[indexPath.row].id
      delegate?.push(viewController: eventPreview)
    case .actionButtons:
      actionPlainObjects[indexPath.row].action?()
    case .collectionIsEmpty:
      break
    }
  }
}

extension MainViewDisplayCollection: TemplateModelCollectionDelegate {
  func templateModelCollectionDidUpdateData() {
    delegate?.updateUI()
  }
}

extension MainViewDisplayCollection: EventPreviewTableViewCellDelegate {
  func eventCellAcceptButtonPressed(_ eventCell: EventPreviewTableViewCell) {
    guard let indexPath = delegate?.getIndexPath(from: eventCell) else {
      assertionFailure("IndexPath is unknown")
      return
    }
    let viewController = ViewControllersFactory.eventRegistrationOrAuthViewController(
      eventId: modelCollection[indexPath.row].id
    )
    delegate?.push(viewController: viewController)
  }
}
