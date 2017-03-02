//
//  Constants.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 27/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

// MARK: - Constants for project
final class Constants {

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

  }

}
