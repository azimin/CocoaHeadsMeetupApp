//
//  ImporterHelper.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 02/05/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class ImporterHelper {
  static func importToSave(event: EventEntity?,
                           to type: ImportType,
                           from viewController: UIViewController,
                           with additionalAction: Action? = nil) {
    if let event = event {
      Importer.import(event: event, to: type, completion: { result in
        defer {
          additionalAction?()
        }

        switch result {
        case .success:
          viewController.showMessageAlert(title: "Успешно добавлено".localized)
          realmWrite {
            switch type {
            case .calendar:
              event.importingState.toCalendar = true
            case .reminder:
              event.importingState.toReminder = true
            }
          }
        case .permissionError:
          viewController.showMessageAlert(title: "Нет прав доступа".localized)
        case .saveError(_):
          viewController.showMessageAlert(title: "Ошибка сохранения".localized)
        }
      })
    } else {
      assertionFailure("No event entity")
    }
  }
}
