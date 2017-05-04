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
        return
    }

    let request = RequestPlainObject.Requests.editProfile(token: token,
                                                          email: user.email,
                                                          phone: user.phone,
                                                          company: user.company,
                                                          position: user.position)
    Server.standard.request(request) { response, error in
      completion(response?.success ?? false)
    }
    
  }
}
