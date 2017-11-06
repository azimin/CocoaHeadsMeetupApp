//
//  ProfileViewDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 29/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

final class ProfileViewDisplayCollection: DisplayCollection {
  static var modelsForRegistration: [CellViewAnyModelType.Type] {
    return [ProfilePhotoTableViewCellModel.self,
            LabelTableViewCellModel.self,
            ActionTableViewCellModel.self]
  }

  weak var delegate: DisplayCollectionDelegate?
  private var userActions: [ActionTableViewCellModel] {
    var actions = [ActionTableViewCellModel]()

    var status: GiveSpeechEntity.GiveSpeechStatus = .canGiveNew
    if modelCollection.count > 0 {
      status = modelCollection[modelCollection.count - 1].status
    }

    let giveSpeechObject = ActionPlainObject(text: status.statusText, imageName: nil) { [weak self] in
      switch status {
      case .canGiveNew:
        let giveSpeechViewController = Storyboards.Profile.instantiateGiveSpeechViewController()
        self?.delegate?.push(viewController: giveSpeechViewController)
      case .waiting:
        let giveSpeechViewController = Storyboards.Profile.instantiateGiveSpeechViewController()
        if let modelCollection = self?.modelCollection, modelCollection.count > 0 {
          giveSpeechViewController.sentGiveSpeechId = modelCollection[modelCollection.count - 1].id
        }
        self?.delegate?.push(viewController: giveSpeechViewController)
      case .loading, .unknown:
        return
      }
    }
    let giveSpeechAction = ActionTableViewCellModel(action: giveSpeechObject)

    let creatorsObject = ActionPlainObject(text: "Создатели".localized, imageName: nil) { [weak delegate] in
      let creators = Storyboards.Profile.instantiateCreatorsViewController()
      delegate?.push(viewController: creators)
    }
    let creatorsAction = ActionTableViewCellModel(action: creatorsObject)

    let askQuestionObject = ActionPlainObject(text: "Задать вопрос".localized, imageName: nil) {
      if let url = URL(string: "mailto:\(Constants.supportEmail)"), self.canSendMail {
        UIApplication.shared.open(url)
      }
    }
    let askQuestionAction = ActionTableViewCellModel(action: askQuestionObject)

    actions.append(giveSpeechAction)
    actions.append(creatorsAction)

    if canSendMail {
      actions.append(askQuestionAction)
    }
    return actions
  }

  enum `Type` {
    case userHeader
    case userContacts
    case userActions
  }

  var sections: [Type] = [.userHeader, .userContacts, .userActions]

  var user: UserEntity {
    guard let user = UserPreferencesEntity.value.currentUser else {
      fatalError("Authorization error")
    }
    return user
  }

  var modelCollection: DataModelCollection<GiveSpeechEntity> = {
    return DataModelCollection(type: GiveSpeechEntity.self).sorted(byKeyPath: #keyPath(GiveSpeechEntity.id))
  }()

  var numberOfSections: Int {
    return sections.count
  }

  init(delegate: DisplayCollectionDelegate?) {
    self.delegate = delegate
  }

  private var canSendMail: Bool {
    if let url = URL(string: "mailto:\(Constants.supportEmail)"), UIApplication.shared.canOpenURL(url) {
      return true
    }
    return false
  }

  func numberOfRows(in section: Int) -> Int {
    switch sections[section] {
    case .userHeader:
      return 1
    case .userContacts:
      return user.contacts.count
    case .userActions:
      return self.userActions.count
    }
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    switch sections[indexPath.section] {
    case .userHeader:
      return ProfilePhotoTableViewCellModel(userEntity: user)
    case .userContacts:
      let key = Array(user.contacts.keys).sorted(by: > )[indexPath.row]
      let value = user.contacts[key] ?? ""
      return LabelTableViewCellModel(title: key, description: value)
    case .userActions:
      return userActions[indexPath.row]
    }
  }

  func didSelect(indexPath: IndexPath) {
    switch sections[indexPath.section] {
    case .userActions:
      if let action = userActions[indexPath.row].action.action {
        action()
      }
    case .userHeader, .userContacts:
      break
    }
  }
}
