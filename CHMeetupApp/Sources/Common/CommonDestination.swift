//
//  CommonDestination.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 25/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

// FIXME: - Make all destinations unique
enum CommonDestination: Destination {
  case eventPreview(id: Int)
  case askQuestion
  case creators
  case giveSpeech
  case registrationPreview(id: Int)
  case speechPreview(id: Int)
  case profileEdit

  var route: Route {
    switch self {
    case let .eventPreview(id):
      let eventPreviewViewController = Storyboards.EventPreview.instantiateEventPreviewViewController()
      eventPreviewViewController.selectedEventId = id
      return Route(to: eventPreviewViewController, direction: .show)
    case .askQuestion:
      return Route(to: Storyboards.Profile.instantiateAskQuestionViewController(), direction: .show)
    case .creators:
      return Route(to: Storyboards.Profile.instantiateCreatorsViewController(), direction: .show)
    case .giveSpeech:
      return Route(to: Storyboards.Profile.instantiateGiveSpeechViewController(), direction: .show)
    case let .registrationPreview(id):
      let registrationPreview = Storyboards.EventPreview.instantiateRegistrationPreviewViewController()
      registrationPreview.selectedEventId = id
      return Route(to: registrationPreview, direction: .show)
    case let .speechPreview(id):
      let speechPreview = Storyboards.EventPreview.instantiateSpeechPreviewViewController()
      speechPreview.selectedSpeechId = id
      return Route(to: speechPreview, direction: .show)
    case .profileEdit:
      return Route(to: Storyboards.Profile.instantiateProfileEditViewController(), direction: .show)
    }
  }
}
