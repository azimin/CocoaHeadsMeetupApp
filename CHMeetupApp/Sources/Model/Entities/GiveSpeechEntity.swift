//
//  GiveSpeechEntity.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 16/08/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation
import RealmSwift

class GiveSpeechEntity: Object {

  enum GiveSpeechStatus: String {
    case waiting
    case canGiveNew
    case unknown
    case loading

    var allowGiveSpeech: Bool {
      switch self {
      case .canGiveNew:
        return true
      case .waiting, .unknown, .loading:
        return false
      }
    }

    var statusText: String {
      switch self {
      case .waiting:
        return "Ожидайте подтверждения".localized
      case .canGiveNew:
        return "Стать спикером".localized
      case .unknown:
        return "Нет статуса".localized
      case .loading:
        return "Загрузка статуса".localized
      }
    }
  }

  dynamic var id: Int = 0

  dynamic var title: String = ""
  dynamic var descriptionText: String = ""

  dynamic var statusValue: String = "unknown"
  var status: GiveSpeechStatus {
    get {
      return GiveSpeechStatus(rawValue: statusValue) ?? .unknown
    }
    set {
      realmWrite {
        statusValue = newValue.rawValue
      }
    }
  }

  override static func primaryKey() -> String? {
    return "id"
  }

}
