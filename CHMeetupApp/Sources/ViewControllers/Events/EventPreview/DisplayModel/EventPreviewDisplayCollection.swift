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
      if let event = event {
        speeches.content = TemplateModelCollection.Content.list(event.speeches)
      }

      setNeedsReloadData()
    }
  }

  var speeches: TemplateModelCollection<SpeechEntity> = {
    return TemplateModelCollection(templatesCount: 3)
  }()

  init() {
    speeches.delegate = self
  }

  weak var delegate: DisplayCollectionDelegate?

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

  private var sections: [Type] = []
  private var actionPlainObjects: [ActionPlainObject] = []

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

  func updateActionCellsSection(on viewController: UIViewController,
                                with tableView: UITableView,
                                event: EventEntity) {
    actionPlainObjects = []

    let actionCell = ActionCellConfigurationController()

    let calendarPermissionCell = actionCell.createImportAction(for: event,
                                                               on: viewController,
                                                               for: .calendar) { [weak self] in
      self?.delegate?.updateUI()
    }

    let remindersPermissionCell = actionCell.createImportAction(for: event,
                                                                on: viewController,
                                                                for: .reminder) { [weak self] in
      self?.delegate?.updateUI()
    }

    if let calendarPermissionCell = calendarPermissionCell {
      actionPlainObjects.append(calendarPermissionCell)
    }

    if let remindersPermissionCell = remindersPermissionCell {
      actionPlainObjects.append(remindersPermissionCell)
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
      return speeches.count
    case .additionalCells:
      return event != nil ? actionPlainObjects.count : 0
    }
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
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
      return SpeechPreviewTableViewCellModel(entity: speeches[indexPath.row])
    case .description:
      return ActionTableViewCellModel(action: ActionPlainObject(text: event?.descriptionText ?? ""))
    case .additionalCells:
      return ActionTableViewCellModel(action: actionPlainObjects[indexPath.row])
    }
  }

  func didSelect(indexPath: IndexPath) {
    let type = sections[indexPath.section]
    switch type {
    case .address:
      addressActionObject?.action?()
    case .speaches:
      if let event = event {
        if speeches[indexPath.row].isTemplate {
          return
        }
        let viewController = Storyboards.EventPreview.instantiateSpeechPreviewViewController()
        viewController.selectedSpeechId = event.speeches[indexPath.row].id
        delegate?.push(viewController: viewController)
      }
    case .additionalCells:
      actionPlainObjects[indexPath.row].action?()
    case .description, .location:
      break
    }
  }
}

extension EventPreviewDisplayCollection: TemplateModelCollectionDelegate {
  func templateModelCollectionDidUpdateData() {
    delegate?.updateUI()
  }
}
