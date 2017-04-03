//
//  ActionCellConfigurationController.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 25/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class ActionCellConfigurationController {

  typealias Action = () -> Void

  func checkAccess(on viewController: UIViewController,
                   for type: PermissionsManager.`Type`, with action: Action?) -> ActionPlainObject? {
    var actionPlainObject: ActionPlainObject?

    switch  type {
    case .reminders:
      if !PermissionsManager.isAllowed(type: type) {
        actionPlainObject = ActionPlainObject(text: "Включите оповещения, чтобы не пропустить событие".localized,
                                              imageName: "img_icon_notification", action: {
                                              self.requireAccess(from: viewController, to: type,
                                                                 with: action)
        })
        return actionPlainObject
      }
    case .calendar:
      // FIXME: insert the real image
      if !PermissionsManager.isAllowed(type: type) {
        actionPlainObject = ActionPlainObject(text: "Включите календарь, чтобы не пропустить событие".localized,
                                              imageName: "img_icon_notification", action: {
                                                self.requireAccess(from: viewController, to: type,
                                                                   with: action)
        })
        return actionPlainObject
      }
    case .camera, .photosLibrary, .notifications:
      break
    }
    return nil
  }

  private func requireAccess(from viewController: UIViewController,
                             to type: PermissionsManager.`Type`, with action: Action?) {
      PermissionsManager.requireAccess(from: viewController,
                                       to: type, completion: { success in
                                        if success {
                                          DispatchQueue.main.async {
                                            action?()
                                          }
                                        }
      })
  }

  func modelForActionCell(with actionPlainObject: ActionPlainObject) -> ActionTableViewCellModel {
    return ActionTableViewCellModel(action: actionPlainObject)
  }
}
