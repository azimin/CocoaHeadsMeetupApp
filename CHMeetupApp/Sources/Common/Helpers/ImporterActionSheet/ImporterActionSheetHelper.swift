//
//  ImporterActionSheetHelper.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 20/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import RealmSwift
import UIKit

class ImporterActionSheetHelper {
  static func createActionSheet(on viewController: UIViewController, for event: EventEntity) -> UIViewController? {
    var actionSheet: UIAlertController?
      if !event.isAdded.addedToCalendar || !event.isAdded.addedToReminder {
        actionSheet = UIAlertController(title: "Добавить в".localized, message: nil, preferredStyle: .actionSheet)
        createActions(for: actionSheet, with: event)
        return actionSheet
    }
    return actionSheet
  }

  private static func createActions(for actionSheet: UIAlertController?, with event: EventEntity) {
    if !event.isAdded.addedToCalendar {
      let action = UIAlertAction(title: "В календарь".localized, style: .cancel, handler: { (_) in
        Importer.import(event: event, to: .calendar, completion: { _ in
            realmWrite {
              event.isAdded.addedToCalendar = true
            }
        })
      })
      PermissionsManager.isAllowed(type: .calendar) ? actionSheet?.addAction(action) : print("Calendar is not allowed")
    }
  if !event.isAdded.addedToReminder {
    let action = UIAlertAction(title: "В напоминания".localized, style: .cancel, handler: { (_) in
      Importer.import(event: event, to: .reminder, completion: { _ in
        realmWrite {
          event.isAdded.addedToReminder = true
        }
      })
    })
    PermissionsManager.isAllowed(type: .reminders) ? actionSheet?.addAction(action) : print("Reminders is not allowed")
    }
  }
}
