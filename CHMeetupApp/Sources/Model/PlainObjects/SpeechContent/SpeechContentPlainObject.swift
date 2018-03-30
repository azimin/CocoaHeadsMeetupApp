//
//  SpeechContentPlainObject.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 26/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

struct SpeechContentPlainObject {

  enum SpeechContentType: String {
    case video
    case slide
    case unknown

    var name: String? {
      switch self {
      case .video:
        return "Видео"
      case .slide:
        return "Слайды"
      case .unknown:
        return nil
      }
    }
  }

  let id: Int

  let title: String
  let description: String

  let linkURL: URL
  let type: SpeechContentType
}
