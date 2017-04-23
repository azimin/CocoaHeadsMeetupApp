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
  static func createActionSheet(on viewController: UIViewController, with event: EventEntity) {
    if (PermissionsManager.isAllowed(type: .calendar) || PermissionsManager.isAllowed(type: .reminders)) &&
      (!event.isAdded.addedToCalendar || !event.isAdded.addedToReminder) {
        let actionSheet = UIAlertController(title: "Добавить в".localized, message: nil, preferredStyle: .actionSheet)
        createActions(for: actionSheet, with: event)
        viewController.present(viewController: actionSheet)
    }
  }

  private static func createActions(for actionSheet: UIAlertController, with event: EventEntity) {
    let addToCalendar = UIAlertAction(title: "Календарь".localized, style: .default, handler: { _ in
      Importer.import(event: event, to: .calendar, completion: { _ in
        realmWrite {
          event.isAdded.addedToCalendar = true
        }
      })
    })
    PermissionsManager.isAllowed(type: .calendar) && !event.isAdded.addedToCalendar ?
      actionSheet.addAction(addToCalendar) : print("Calendar is not allowed or event added")

    let addToReminder = UIAlertAction(title: "Напоминания".localized, style: .default, handler: { _ in
      Importer.import(event: event, to: .reminder, completion: { _ in
          realmWrite {
            event.isAdded.addedToReminder = true
          }
      })
    })
    PermissionsManager.isAllowed(type: .reminders) && !event.isAdded.addedToReminder ?
      actionSheet.addAction(addToReminder) : print("Reminders is not allowed or event added")

    let cancel = UIAlertAction(title: "Отменить".localized, style: .cancel, handler: nil)
    actionSheet.addAction(cancel)
  }
}
