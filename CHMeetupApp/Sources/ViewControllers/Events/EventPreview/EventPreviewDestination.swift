//
//  EventPreviewRouter.swift
//  CHMeetupApp
//
//  Created by Igor Voynov on 19.04.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

enum EventPreviewDestination: Destination {
  
  case registration
  var route: Route {
    switch self {
    case .registration:
      if LoginProcessController.isLogin {
        return Route(to: Storyboards.EventPreview.instantiateRegistrationPreviewViewController(), direction: .show)
      } else {
        return Route(to: Storyboards.Profile.instantiateAuthViewController(), direction: .createPoint)
      }
    }
  }
}
