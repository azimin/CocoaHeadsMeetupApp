//
//  SocialResponse.swift
//  CHMeetupApp
//
//  Created by Sergey Zapuhlyak on 11/02/2017.
//  Copyright © 2017 Sergey Zapuhlyak. All rights reserved.
//

import Foundation

class SocialResponse: NSObject {

  var error: String?

  required override init() {
    super.init()
  }

  func readDictionary(_ dict: [String: Any]) {
    self.error = dict["error"] as? String
  }
}
