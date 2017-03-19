//
//  Constants.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 27/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

// MARK: - Constants for project
final class Constants {

  static let apiBase = "http://upapi.ru/method/"

  struct Vkontakte {
    static let clientId = "5895589"
    static let scope = "wall,email,offline,nohttps"
    static let redirect = "vk\(clientId)://authorize"
  }

  struct Facebook {
    static let clientId = "1863830253895861"
    static let redirect = "fb\(clientId)://authorize"
  }

  struct Twitter {
    static let apiBaseOAuth = "https://api.twitter.com/"
    static let clientId = "319871078148574"
    static let redirect = "tw\(Constants.Twitter.clientId)://success"
    static let key = "8tH84hNpnfVUi1GH5zQYMA"
    static let secret = "Y641ZyNF3A9rNXfTEV4Uy4QxI8cSBsbkwghVl2FcqA"
    static let versionOAuth = "1.0"
    static let signatureMethod = "HMAC-SHA1"
  }

  struct SystemSizes {
    static let cornerRadius: CGFloat = 5
    static let textSize: CGFloat = 15
  }

}
