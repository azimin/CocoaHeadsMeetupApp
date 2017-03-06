//
//  SocialEntity.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 04/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation
import RealmSwift

class SocialEntity: Object {
  dynamic var id: Int = 0

  dynamic var name: String = ""
  dynamic var url: String = ""
  dynamic var isPrivate: Bool = true

  private let users = LinkingObjects(fromType: UserEntity.self, property: "socials")

  var user: UserEntity? {
    return users.first
  }

  override static func primaryKey() -> String? {
    return "id"
  }
}
