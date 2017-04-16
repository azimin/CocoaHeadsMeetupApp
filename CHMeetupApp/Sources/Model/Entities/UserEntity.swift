//
//  UserEntity.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 04/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation
import RealmSwift

class UserEntity: Object {
  dynamic var id: Int = 0

  dynamic var name: String = ""
  dynamic var lastName: String = ""

  dynamic var company: String?
  dynamic var position: String?

  dynamic var info: String = ""

  dynamic var phone: String?
  dynamic var email: String = ""

  dynamic var isSpeaker: Bool = false
  dynamic var photoURL: String?

  let speeches = List<SpeechEntity>()
  let socials = List<SocialEntity>()

  override static func primaryKey() -> String? {
    return "id"
  }

  dynamic var fullName: String {
    return name + " " + lastName
  }
}
#if DEBUG
  extension UserEntity {
  static var templateEntity: UserEntity {

    let names = ["Ivan", "Petr", "Anton"]
    let lastNames = ["Ivanov", "Petrov", "Antonov"]
    let company = ["google", "yandex", "apple", nil]
    let positions = ["developer", "manager", nil]
    let info = ["hello", "hi"]
    let phone = ["+79426283936", nil]
    let email = ["1@2.ru", "2@2.ru", "3@2.ru", "4@2.ru"]
    let photos = ["http://yandex.ru/logo.png", nil]

    let entity = UserEntity()
    entity.name <= names.rand
    entity.lastName <= lastNames.rand
    entity.company <= company.rand
    entity.position <= positions.rand
    entity.info <= info.rand
    entity.phone <= phone.rand
    entity.email <= email.rand
    entity.isSpeaker = Bool.rand
    entity.photoURL <= photos.rand
    entity.speeches.append(SpeechEntity.templateEntity)
    entity.socials.append(SocialEntity.templateEntity)
    return entity
  }

  var contacts: [String: String] {
    var userContacts = [String: String]()
    userContacts["Телефон".localized] <= phone.ifNotEmpty
    userContacts["Email".localized] <= email.ifNotEmpty
    return userContacts
  }
}
#endif
