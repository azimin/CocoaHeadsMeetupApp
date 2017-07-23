//
//  PushHandler.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 18/07/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

typealias PushSequence = [AnyHashable : Any]

final class PushHandler {

  private static let actionKey = "action"
  private var router: UniversalRouter!

  enum PushActionType: String {
    case updateRegistrationState = "update_registration_state"
    case unknown
  }

  func handle(data: PushSequence, via router: UniversalRouter) {
    self.router = router
    var actionType: PushActionType = .unknown

    if let action = data[PushHandler.actionKey] as? String {
      actionType = PushActionType(rawValue: action) ?? .unknown
    }

    switch actionType {
    case .updateRegistrationState:
      registrationStatePush(data: data)
    case .unknown:
      assertionFailure("Unknown action for push")
    }
  }

  // MARK: - Private methods

  private func registrationStatePush(data: PushSequence) {
    guard
      let eventId = data["eventId"] as? Int,
      let status = data["status"] as? String
    else { return }

    router.activate(section: .anonses)
    router.updateAnonseStatus(for: eventId, status: status)
  }

}
