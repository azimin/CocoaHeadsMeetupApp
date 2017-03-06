//
//  UserPlainObject+DataBase.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 05/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation
import RealmSwift

extension UserPlainObject: DataBasePlainObjectType {
  typealias DataModelType = UserEntity

  static func mapFromObject(object: DataModelType) -> UserPlainObject {
    return UserPlainObject(json: [:])!
  }

  func mapToObject() -> UserEntity {
    return UserEntity()
  }
}
