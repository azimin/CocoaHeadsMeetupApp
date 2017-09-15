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
    static var baseParams: RequestParams {
      var baseParams = ["token": UserPreferencesEntity.value.currentUser?.token ?? ""]

      #if DEBUG
        baseParams["debug"] = "1"
      #endif

      return baseParams
    }
  }

  struct Vkontakte {
    static let clientId = "5895589"
    static let scope = "email,offline,nohttps"
    static let redirect = "vk\(clientId)://authorize"
  }

  struct Facebook {
    static let clientId = "1863830253895861"
    static let scope = "email"
    static let redirect = "fb\(clientId)://authorize"
  }

	struct GitHub {
		static let clientId = "92ad5bdbcacdd2db8d97"
		static let scope = "user:email"
		static let redirect = "github\(clientId)://authorize"
	}

  struct SystemSizes {
    static let cornerRadius: CGFloat = 5
    static let textSize: CGFloat = 15
    //Used for getting border width
    static let imageViewBorderWidthPercentage: CGFloat = 0.04
  }

  struct TemplatesCounts {
    static let creators: Int = 10
  }

  struct Keys {
    static let token = "token"
  }
}
