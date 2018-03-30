//
//  UserEntity.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 04/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation
import RealmSwift

final class UserEntity: TemplatableObject, TemplateEntity {
  enum UserStatus: String {
    case complete
    case requiresCompletion
    case unknown
  }

  @objc dynamic var id: Int = 0
  @objc dynamic var remoteId: Int = 0
  @objc dynamic var name: String = ""
  @objc dynamic var lastName: String = ""

  @objc dynamic var company: String?
  @objc dynamic var position: String?

  @objc dynamic var info: String = ""

  @objc dynamic var phone: String?
  @objc dynamic var email: String = ""

  @objc dynamic var isSpeaker: Bool = false
  @objc dynamic var photoURL: String?
  @objc dynamic var token: String?
  @objc dynamic var statusValue: String = ""

  var status: UserStatus {
    get {
      return UserStatus(rawValue: statusValue) ?? .unknown
    }
    set {
      realmWrite {
        statusValue = newValue.rawValue
      }
    }
  }

  var canContinue: Bool {
    switch status {
    case .complete:
      return true
    case .requiresCompletion:
      return false
    case .unknown:
      return !(name.isEmpty || lastName.isEmpty || email.isEmpty)
    }
  }

  let speeches = List<SpeechEntity>()
  let socials = List<SocialEntity>()

  override static func primaryKey() -> String? {
    return "id"
  }

  @objc dynamic var fullName: String {
    return name + " " + lastName
  }
}

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
