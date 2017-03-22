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
    var model: ActionTableViewCellModel!

    if !PermissionsManager.isAllowed(type: .reminders) {
      let actionPlainObject = ActionPlainObject(handler: "Включите уведомления, чтобы не пропустить мероприятие",
                                                imageName: "img_icon_notification")
      model =  ActionTableViewCellModel(action: actionPlainObject)
    } else {
      let actionPlainObject = ActionPlainObject(handler: "Уведомления включены",
                                                imageName: "img_icon_notification")
      model =  ActionTableViewCellModel(action: actionPlainObject)
    }
    return model
  }

  func action(on view: UIViewController) {
    PermissionsManager.requireAccess(from: view, to: .reminders, completion: { _ in })
  }
}
