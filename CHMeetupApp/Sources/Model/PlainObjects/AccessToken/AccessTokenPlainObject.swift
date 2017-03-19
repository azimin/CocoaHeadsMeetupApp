//
//  AccessTokenPlainObject.swift
//  CHMeetupApp
//
//  Created by Sergey Zapuhlyak on 16/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

struct AccessTokenPlainObject {
  let key: String
  let secret: String
  let verifier: String?
  let screenName: String?
  let userID: String?
}
