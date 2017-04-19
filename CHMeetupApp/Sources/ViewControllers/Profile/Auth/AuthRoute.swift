//
//  AuthRouter.swift
//  CHMeetupApp
//
//  Created by Igor Voynov on 19.04.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

enum AuthRoute: Route {
  case registration

  var rule: RouteRule {
    switch self {
    case .registration:
      return (Storyboards.EventPreview.instantiateRegistrationPreviewViewController(), .pop(position: -1))
    }
  }
}
