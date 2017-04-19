//
//  EventPreviewRouter.swift
//  CHMeetupApp
//
//  Created by Igor Voynov on 19.04.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

enum EventPreviewRoute: Route {
  case registration

  var rule: RouteRule {
    switch self {
    case .registration:
      if LoginProcessController.isLogin {
        return (Storyboards.EventPreview.instantiateRegistrationPreviewViewController(), .push)
      } else {
        let authVC = Storyboards.Profile.instantiateAuthViewController()
        authVC.router.nextTransition = AuthRoute.registration
        print("nextTransition:", authVC.router.nextTransition ?? "nil")
        return (authVC, .push)
      }
    }
  }
}
