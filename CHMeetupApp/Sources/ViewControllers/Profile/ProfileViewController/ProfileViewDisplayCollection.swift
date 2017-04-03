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

  var user: UserEntity {
    guard let user = UserPreferencesEntity.value.currentUser else {
      fatalError("Authorization error")
    }
    return user
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
