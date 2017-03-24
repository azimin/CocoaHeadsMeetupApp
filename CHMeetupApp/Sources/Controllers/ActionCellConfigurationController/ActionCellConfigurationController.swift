//
//  ActionCellConfigurationController.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 21/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class ActionCellConfigurationController {
  func configureCellWithPermisson() -> ActionTableViewCellModel {
    let `isHidden` = PermissionsManager.isAllowed(type: .reminders)
    let actionPlainObject = ActionPlainObject(handler: "Включите уведомления, чтобы не пропустить событие".localized,
                                              imageName: "img_icon_notification",
                                              isEnable: true, isHidden: isHidden)
    let model = ActionTableViewCellModel(action: actionPlainObject)
    return model
  }

  func action(on view: UIViewController, with tableView: UITableView, cellAt indexPath: IndexPath) {
    PermissionsManager.requireAccess(from: view, to: .reminders, completion: { success in
      if success {
        DispatchQueue.main.async {
          let cell = tableView.cellForRow(at: indexPath)
          cell?.isHidden = success
        }
      }
    })
  }
}
