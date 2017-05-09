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
  private var userActions: [ActionTableViewCellModel] = []

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

  var numberOfSections: Int {
    return sections.count
  }

  init(delegate: DisplayCollectionDelegate?) {
    self.delegate = delegate

    let giveSpeechObject = ActionPlainObject(text: "Стать спикером".localized, imageName: nil) { [weak delegate] in
      let giveSpeech = Storyboards.Profile.instantiateGiveSpeechViewController()
      delegate?.push(viewController: giveSpeech)
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

    userActions.append(giveSpeechAction)
    userActions.append(creatorsAction)

    if canSendMail {
      userActions.append(askQuestionAction)
    }
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
