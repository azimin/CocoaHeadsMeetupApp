//
//  UserPreferencesEntity.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 05/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation
import RealmSwift

class UserPreferencesEntity: Object, ObjectSingletone {
  dynamic var isLoggedIn: Bool = false
  dynamic var currentUser: UserEntity?
}
