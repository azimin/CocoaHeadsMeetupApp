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
  static func createActionSheet(on viewController: UIViewController, for event: EventEntity) {
    let isEnableToAddReminder = PermissionsManager.isAllowed(type: .reminders) && !event.isAdded.toReminder
    let isEnableToAddCalendar = PermissionsManager.isAllowed(type: .calendar) && !event.isAdded.toCalendar

    if isEnableToAddCalendar || isEnableToAddReminder {
        let actionSheet = UIAlertController(title: "Добавить в".localized, message: nil, preferredStyle: .actionSheet)
        createActions(for: actionSheet, for: event)
        viewController.present(viewController: actionSheet)
    }
  }

  private static func createActions(for actionSheet: UIAlertController, for event: EventEntity) {
    let addToCalendar = UIAlertAction(title: "Календарь".localized, style: .default, handler: { _ in
      Importer.import(event: event, to: .calendar, completion: { _ in
        realmWrite {
          event.isAdded.toCalendar = true
        }
      })
    })
    if PermissionsManager.isAllowed(type: .calendar) && !event.isAdded.toCalendar {
      actionSheet.addAction(addToCalendar)
    }

    let addToReminders = UIAlertAction(title: "Напоминания".localized, style: .default, handler: { _ in
      Importer.import(event: event, to: .reminder, completion: { _ in
        realmWrite {
          event.isAdded.toReminder = true
        }
      })
    })
    if PermissionsManager.isAllowed(type: .reminders) && !event.isAdded.toReminder {
      actionSheet.addAction(addToReminders)
    }

    let cancel = UIAlertAction(title: "Отменить".localized, style: .cancel, handler: nil)
    actionSheet.addAction(cancel)
  }
}
