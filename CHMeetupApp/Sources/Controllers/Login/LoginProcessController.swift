//
//  LoginProcessViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 23/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

class LoginProcessController {

  static func setCurrentUser(_ user: UserPlainObject) {
    realmWrite {
      var currentUser: UserEntity
      UserPreferencesEntity.value.isLoggedIn = true

      if UserPreferencesEntity.value.currentUser == nil {
        currentUser = UserEntity()
      } else {
        currentUser = UserPreferencesEntity.value.currentUser!
      }

      currentUser.name = user.name
      currentUser.lastName = user.lastname
      currentUser.photoURL = user.photoUrl ?? ""
      currentUser.company = user.company ?? ""

      UserPreferencesEntity.value.currentUser = currentUser
    }
  }

  static var isLogin: Bool {
    return UserPreferencesEntity.value.isLoggedIn
  }

  static func logout() {
    realmWrite {
      UserPreferencesEntity.value.isLoggedIn = false
    }
  }
}
