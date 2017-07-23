//
//  CreatorsViewDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 20/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import RealmSwift

final class CreatorsViewDisplayCollection: DisplayCollection {
  static var modelsForRegistration: [CellViewAnyModelType.Type] {
    return [CreatorTableViewCellModel.self]
  }

  var creators: TemplateModelCollection<CreatorEntity> = {
    let dataCollection = DataModelCollection(type: CreatorEntity.self)
    return TemplateModelCollection(dataCollection: dataCollection,
                                   templatesCount: Constants.TemplatesCounts.creators)
  }()

  private var activeCreatorsCollection: DataModelCollection<CreatorEntity> = {
    let creators = DataModelCollection(type: CreatorEntity.self)
    return creators.filtered("isActive == 1")
  }()

  private var inactiveCreatorsCollection: DataModelCollection<CreatorEntity> = {
    let creators = DataModelCollection(type: CreatorEntity.self)
    return creators.filtered("isActive == 0")
  }()

  private enum `Type` {
    case active
    case inactive
  }

  weak var delegate: DisplayCollectionWithTableViewDelegate?
  private var sections: [Type] = [.active, .inactive]

  var numberOfSections: Int {
    return sections.count
  }

  func numberOfRows(in section: Int) -> Int {
    switch sections[section] {
    case .active:
      return activeCreatorsCollection.count
    case .inactive:
      return inactiveCreatorsCollection.count
    }
  }

  func headerHeight(for section: Int) -> CGFloat {
    guard let delegate = delegate else {
      assertionFailure("Subscribe to this delegate")
      return 0
    }

    if numberOfRows(in: section) == 0 {
      return 0
    }

    let insets = DefaultTableHeaderView.titleInsets
    let title = headerTitle(for: section)
    let width = delegate.getTableViewSize().width - insets.left - insets.right
    let height = TextFrameAttributes(string: title, width: width).textHeight
    return height + insets.top + insets.bottom
  }

  func headerTitle(for section: Int) -> String {
    switch sections[section] {
    case .active:
      return "Активные".localized
    case .inactive:
      return "Неактивные".localized
    }
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    switch sections[indexPath.section] {
    case .active:
      return CreatorTableViewCellModel(entity: activeCreatorsCollection[indexPath.row])
    case .inactive:
      return CreatorTableViewCellModel(entity: inactiveCreatorsCollection[indexPath.row])
    }
  }

  func didSelect(indexPath: IndexPath) {
    var model: CreatorEntity
    switch sections[indexPath.section] {
    case .active:
      model = activeCreatorsCollection[indexPath.row]
    case .inactive:
      model = inactiveCreatorsCollection[indexPath.row]
    }
    let viewController = Storyboards.Profile.instantiateCreatorDetailViewController()
    viewController.creatorId = model.id
    delegate?.push(viewController: viewController)
  }
}

// MARK: - TemplateModelCollectionDelegate
extension CreatorsViewDisplayCollection: TemplateModelCollectionDelegate {
  func templateModelCollectionDidUpdateData() {
    delegate?.updateUI()
  }
}
