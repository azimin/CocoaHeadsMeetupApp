//
//  CreatorsViewDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 20/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation
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

  weak var delegate: DisplayCollectionWithTableViewDelegate?

  var numberOfSections: Int {
    return 1
  }

  func numberOfRows(in section: Int) -> Int {
    return creators.count
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    return CreatorTableViewCellModel(entity: creators[indexPath.row])
  }

  func didSelect(indexPath: IndexPath) {
    let model = creators[indexPath.row]
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
