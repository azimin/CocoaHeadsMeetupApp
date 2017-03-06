//
//  Realm+WriteFunctions.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 04/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
  public func realmWrite(_ block: (() -> Void)) {
    if self.isInWriteTransaction {
      block()
    } else {
      do {
        try write(block)
      } catch {
        NotificationCenter.default.post(name: .RealmWritingErrorNotifications,
                                        object: nil)
        assertionFailure("Realm write error: \(error)")
      }
    }
  }
}

func realmWrite(realm: Realm = mainRealm, _ block: (() -> Void)) {
  realm.realmWrite(block)
}
