//
//  Constants.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 27/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

typealias ActionCompletionBlock = () -> Void
typealias SuccessCompletionBlock = (_ success: Bool) -> Void

// MARK: - Constants for project
final class Constants {

  static let apiBase = "http://upapi.ru/method/"
  static let supportEmail = "support@cocoaheads.ru"

  struct Server {
    static var baseParams: [String: String] {
      return ["token": UserPreferencesEntity.value.currentUser?.token ?? ""]
    }
  }

  struct Vkontakte {
    static let clientId = "5895589"
    static let scope = "wall,email,offline,nohttps"
    static let redirect = "vk\(clientId)://authorize"
  }

  struct Facebook {
    static let clientId = "1863830253895861"
    static let redirect = "fb\(clientId)://authorize"
  }

  struct SystemSizes {
    static let cornerRadius: CGFloat = 5
    static let textSize: CGFloat = 15
    // Used for getting border width
    static let imageViewBorderWidthPercentage: CGFloat = 0.04
  }

  struct TemplateTextMasks {
    static let replacementCharacter: Character = "X"
    static let phone = "+X (XXX) XXX XX-XX"
  }

  struct TemplatesCounts {
    static let creators: Int = 10
  }

  struct Keys {
    static let token = "token"
  }
}
