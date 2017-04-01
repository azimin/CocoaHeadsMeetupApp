//
//  ProfileViewDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 29/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

struct ProfileViewDisplayCollection: DisplayCollection {
  static var modelsForRegistration: [CellViewAnyModelType.Type] {
    return [UserTableViewHeaderCellModel.self]
  }

  struct CellHeights {
    static let userHeader: CGFloat = 195.0
  }

  enum `Type` {
    case userHeader
  }

  var sections: [Type] = [.userHeader]

  let user: UserEntity = {
    // Template data
    let userEntity = UserEntity()
    userEntity.name = "Dmitriy"
    userEntity.lastName = "Lis"
    userEntity.company = "Nowhere"
    userEntity.position = "iOS Developer"
    return userEntity
  }()

  var fullUserName: String {
    return user.name + " " + user.lastName
  }

  var numberOfSections: Int {
    return sections.count
  }

  func numberOfRows(in section: Int) -> Int {
    switch sections[section] {
    case .userHeader:
      return 1
    }
  }

  func cellHeightFor(_ indexPath: IndexPath) -> CGFloat {
    switch sections[indexPath.section] {
    case .userHeader:
      return CellHeights.userHeader
    }
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    switch sections[indexPath.section] {
    case .userHeader:
      return UserTableViewHeaderCellModel(userEntity: user)
    }
  }
}
