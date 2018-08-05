//
//  NotificationController.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 19/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class NotificationHelper {
  static func viewController(title: String? = nil,
                             description: String? = nil,
                             emoji: String? = nil,
                             completion: @escaping ActionCompletionBlock = {}) -> NotificationViewController {
    let notification = Storyboards.Main.instantiateNotificationViewController()
    notification.titleText = title
    notification.descriptionText = description
    notification.completionBlock = completion
    notification.emoji = emoji
    notification.modalPresentationStyle = .overFullScreen

    return notification
  }
}

extension NotificationHelper {
  static func somethingWrongViewController() -> NotificationViewController {
    let message = "Мы всегда поможем решить вашу проблему, пишите в телеграм канал: @cocoaheads.".localized
    return NotificationHelper.viewController(title: "Что-то пошло не так".localized,
                                             description: message,
                                             emoji: "🔥",
                                             completion: { })
  }
}
