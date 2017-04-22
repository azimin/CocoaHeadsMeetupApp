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
  weak static var event: EventEntity?

  static func createActionSheet(on viewController: UIViewController) {
    guard let event = event else {
      assertionFailure("EventEntity is nil!")
      return
    }
    let actionSheet = UIAlertController(title: "Добавить в".localized, message: nil, preferredStyle: .actionSheet)
    createActions(for: actionSheet, with: event)
    viewController.present(viewController: actionSheet)
  }

  private static func createActions(for actionSheet: UIAlertController, with event: EventEntity) {
    if !event.isAdded.addedToCalendar {
      let action = UIAlertAction(title: "В календарь".localized, style: .default, handler: { (_) in
        Importer.import(event: event, to: .calendar, completion: { _ in
          realmWrite {
              event.isAdded.addedToCalendar = true
            }
        })
      })
      PermissionsManager.isAllowed(type: .calendar) ? actionSheet.addAction(action) : print("Calendar is not allowed")
    }
    if !event.isAdded.addedToReminder {
    let action = UIAlertAction(title: "В напоминания".localized, style: .default, handler: { (_) in
      Importer.import(event: event, to: .reminder, completion: { _ in
        realmWrite {
          event.isAdded.addedToReminder = true
        }
      })
    })
    PermissionsManager.isAllowed(type: .reminders) ? actionSheet.addAction(action) : print("Reminders is not allowed")
    }

    let action = UIAlertAction(title: "Отменить".localized, style: .cancel, handler: nil)
    actionSheet.addAction(action)
  }
}
