//
//  ProfileController.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 04/05/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

class ProfileController {
  static func save(completion: @escaping (_ success: Bool) -> Void) {
    guard let user = UserPreferencesEntity.value.currentUser,
      let token = user.token else {
        completion(false)
        return
    }

    let request = RequestPlainObject.Requests.editProfile(token: token,
                                                          email: user.email,
                                                          phone: user.phone,
                                                          company: user.company,
                                                          position: user.position)
    Server.standard.request(request) { response, _ in
      completion(response?.success ?? false)
    }
  }
}
