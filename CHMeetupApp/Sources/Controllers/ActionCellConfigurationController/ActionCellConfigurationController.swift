//
//  ActionCellConfigurationController.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 21/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

protocol ActionCellConfigurationDelegate: class {
  func successPermission(on tableView: UITableView, cellAt indexPath: IndexPath, with result: Bool)
}

class ActionCellConfigurationController {

  weak var delegate: ActionCellConfigurationDelegate?

  // FIXME: Remove when necessary
  var actionPlainObjects: [ActionPlainObject] = []

  func checkPermission() {
    if !PermissionsManager.isAllowed(type: .reminders) {
      let actionPlainObject = ActionPlainObject(handler: "Включите оповещения, чтобы не пропустить событие",
                                                imageName: "img_icon_notification")
      actionPlainObjects.append(actionPlainObject)
    }
  }

  func modelForRemindersPermission(at indexPath: IndexPath) -> ActionTableViewCellModel {
    let model = ActionTableViewCellModel(action: actionPlainObjects[indexPath.row])
    return model
  }

  func requestAccess(on viewController: UIViewController, with tableView: UITableView, cellAt indexPath: IndexPath) {
    PermissionsManager.requireAccess(from: viewController, to: .reminders, completion: { result in
      self.delegate?.successPermission(on: tableView, cellAt: indexPath, with: result)
    })
  }
}
