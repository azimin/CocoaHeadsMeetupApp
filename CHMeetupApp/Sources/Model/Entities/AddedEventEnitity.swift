//
//  AddedEventEnitity.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 20/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation
import RealmSwift

class AddedEventEntity: Object {
  dynamic var toCalendar = false
  dynamic var toReminder = false
}
