//
//  SpeechContentPlainObject+Requests.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 27/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

extension SpeechContentPlainObject: PlainObjectType {

  struct Requests {

    // Content list
    static func contentsOnSpeech(with id: Int) -> Request<[SpeechContentPlainObject]> {
      return Request(query: "contents/speech/\(id)")
    }
  }

  init?(json: JSONDictionary) {
    guard
      let id = json["content_id"] as? Int,
      let title = json["title"] as? String,
      let description = json["description"] as? String,
      let link = json["link"] as? String,
      let url = URL(string: link),
      let type = json["type"] as? String
      else { return nil }

    self.id = id
    self.title = title
    self.description = description
    self.linkURL = url
    if let contentType = SpeechContentType(rawValue: type) {
        self.type = contentType
    } else {
        self.type = .unknown
    }
  }
}
