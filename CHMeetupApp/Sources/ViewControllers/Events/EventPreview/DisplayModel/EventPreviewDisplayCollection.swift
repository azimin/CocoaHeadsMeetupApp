//
//  GiveSpeechDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 21/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import CoreLocation

class EventPreviewDisplayCollection: DisplayCollection {
  static var modelsForRegistration: [CellViewAnyModelType.Type] {
    return [ActionTableViewCellModel.self, TimePlaceTableViewCellModel.self, SpeechPreviewTableViewCellModel.self]
  }

  var event: EventEntity? {
    didSet {
      if let place = event?.place {
        addressActionObject = ActionPlainObject(text: place.address, imageName: nil, action: { [weak self] in
          let location = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
          let actionSheet = MapsActionSheetHelper.prepareActonSheet(with: location)
          if let actionSheet = actionSheet {
            DispatchQueue.main.async {
              self?.delegate?.present(viewController: actionSheet)
            }
          }
        })
      }
      setNeedsReloadData()
    }
  }

  func createActionCellsSection(on viewController: UIViewController, with tableView: UITableView) {
    let actionCell = ActionCellConfigurationController()

    let action = {
      guard let index = self.indexPath else {
        return
      }
      self.actionPlainObjects.remove(at: index.row)
      tableView.deleteRows(at: [index], with: .left)
    }

    let calendarPermissonCell = actionCell.checkAccess(on: viewController, for: .calendar, with: action)
    let remindersPermissionCell = actionCell.checkAccess(on: viewController, for: .reminders, with: action)

    if let calendarCell = calendarPermissonCell {
      actionPlainObjects.append(calendarCell)
    }
    if let remindersCell = remindersPermissionCell {
      actionPlainObjects.append(remindersCell)
    }
  }

  weak var delegate: DisplayCollectionDelegate?

  var indexPath: IndexPath?
  // MARK: - Adrsess Plain Object

  private var addressActionObject: ActionPlainObject?

  // MARK: - Reload with cache engine

  func setNeedsReloadData() {
    guard isReloadDataInProgress == false else {
      return
    }

    isReloadDataInProgress = true
    OperationQueue.main.addOperation { [weak self] in
      self?.reloadData()
      self?.isReloadDataInProgress = false
    }
  }

  private var isReloadDataInProgress = false

  private func reloadData() {
    updateSections()
    delegate?.updateUI()
  }

  // MARK: - Sections

  enum `Type` {
    case location
    case address
    case speaches
    case description
    case additionalCells
  }

  var sections: [Type] = []
  var actionPlainObjects: [ActionPlainObject] = []

  func updateSections() {
    sections = []

    // We always show location cell, but sometimes it's template
    sections.append(.location)

    // We show adress cell only if place exist
    if event?.place != nil {
      sections.append(.address)
    }

    // We always show speaches and description cell, but sometimes it's template
    sections.append(.speaches)
    sections.append(.description)

    // We show additional cells only if event exist
    if event != nil {
      sections.append(.additionalCells)
    }
  }

  var numberOfSections: Int {
    return sections.count
  }

  func numberOfRows(in section: Int) -> Int {
    switch sections[section] {
    case .location, .address, .description:
      return 1
    case .speaches:
      return event?.speeches.count ?? 0
    case .additionalCells:
      return actionPlainObjects.count
    }
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    let actionCell = ActionCellConfigurationController()
    let type = sections[indexPath.section]
    switch type {
    case .location:
      if let event = event {
        return TimePlaceTableViewCellModel(event: event)
      } else {
        // Template
        return ActionTableViewCellModel(action: ActionPlainObject(text: "Loading Adress...".localized))
      }
    case .address:
      if let actionObject = addressActionObject {
        return ActionTableViewCellModel(action: actionObject)
      } else {
        assertionFailure("Should not be reached")
        return ActionTableViewCellModel(action: ActionPlainObject(text: "Loading location...".localized))
      }
    case .speaches:
      if let speech = event?.speeches[indexPath.row] {
        return SpeechPreviewTableViewCellModel(speech: speech)
      } else {
        fatalError("Should not be reached")
      }
    case .description:
      return ActionTableViewCellModel(action: ActionPlainObject(text: event?.descriptionText ?? ""))
    case .additionalCells:
      return actionCell.modelForActionCell(with: actionPlainObjects[indexPath.row])
    }
  }

  func didSelect(indexPath: IndexPath) {
    let type = sections[indexPath.section]
    switch type {
    case .address:
      addressActionObject?.action?()
    case .speaches:
      if let event = event {
        let viewController = Storyboards.EventPreview.instantiateSpeechPreviewViewController()
        viewController.selectedSpeechId = event.speeches[indexPath.row].id
        delegate?.push(viewController: viewController)
      }
    case .additionalCells:
      self.indexPath = indexPath
      actionPlainObjects[indexPath.row].action?()
    case .description, .location:
      break
    }
  }
}
