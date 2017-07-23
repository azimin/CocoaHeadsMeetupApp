//
//  CreatorEntity.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 01/05/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation
import RealmSwift

final class CreatorEntity: TemplatableObject, TemplateEntity {
  dynamic var id: Int = 0

  dynamic var name: String = ""
  dynamic var info: String?

  dynamic var url: String?
  dynamic var photoURL: String?
  dynamic var isActive: Bool = false

  override static func primaryKey() -> String? {
    return "id"
  }
}
#if DEBUG
  extension CreatorEntity {
    static var templateEntity: CreatorEntity {
      let names = ["Ivan", "Petr", "Anton"]
      let info = ["hello", "hi", nil]
      let urls = ["http://yandex.ru/logo.png", nil]

      let entity = CreatorEntity()
      entity.name <= names.rand
      entity.info <= info.rand
      entity.url <= urls.rand
      entity.photoURL <= urls.rand
      entity.isTemplate = true
      entity.isActive = false

      return entity
    }
  }
#endif
