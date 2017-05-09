//
//  RegistrationConfirmDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 23.04.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
final class RegistrationConfirmDisplayCollection: NSObject, DisplayCollection, DisplayCollectionAction {
  private let regConfirmHeaderTableViewCellHeight: CGFloat = 300.0

  enum `Type` {
    case header
    case actionButtons
  }

  static var modelsForRegistration: [CellViewAnyModelType.Type] {
    return [RegConfirmHeaderTableViewCellModel.self, ActionTableViewCellModel.self]
  }

  private var sections: [Type] = [.header, .actionButtons]
  private var actionPlainObjects: [ActionPlainObject] = []

  weak var delegate: DisplayCollectionDelegate?

  var event: EventEntity?

  func updateActionCellsSection(on viewController: UIViewController,
                                with tableView: UITableView,
                                event: EventEntity) {
    actionPlainObjects = []

    let actionCell = ActionCellConfigurationController()

    let calendarPermissionCell = actionCell.createImportAction(for: event,
                                                               on: viewController,
                                                               for: .calendar) {
                                                                [weak self] in
                                                                self?.delegate?.updateUI()
    }

    let reminderPermissionCell = actionCell.createImportAction(for: event,
                                                                on: viewController,
                                                                for: .reminder) {
                                                                  [weak self] in
                                                                  self?.delegate?.updateUI()
    }

    if let calendarPermissionCell = calendarPermissionCell {
      actionPlainObjects.append(calendarPermissionCell)
    }

    if let reminderPermissionCell = reminderPermissionCell {
      actionPlainObjects.append(reminderPermissionCell)
    }
  }

  var numberOfSections: Int {
    return sections.count
  }

  func height(for indexPath: IndexPath) -> CGFloat {
    switch sections[indexPath.section] {
    case .header:
      return regConfirmHeaderTableViewCellHeight
    case .actionButtons:
      return UITableViewAutomaticDimension
    }
  }

  func numberOfRows(in section: Int) -> Int {
    switch sections[section] {
    case .header:
      return 1 // Only one header cell
    case .actionButtons:
      return event != nil ? actionPlainObjects.count : 0
    }
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    let type = sections[indexPath.section]
    switch type {
    case .header:
      return RegConfirmHeaderTableViewCellModel()
    case .actionButtons:
      return ActionTableViewCellModel(action: actionPlainObjects[indexPath.row])
    }
  }

  func didSelect(indexPath: IndexPath) {
    switch sections[indexPath.section] {
    case .header:
      // Do nothing
      break
    case .actionButtons:
      actionPlainObjects[indexPath.row].action?()
    }
  }
}
