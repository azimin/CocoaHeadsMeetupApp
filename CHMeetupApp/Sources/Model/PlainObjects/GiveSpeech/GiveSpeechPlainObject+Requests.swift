//
//  GiveSpeechPlainObject+Requests.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 16/08/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

extension GiveSpeechPlainObject: PlainObjectType {

  struct Requests {

    /// Returns GiveSpeeches list of concrete user by id
    static func giveSpeechesOfUser(with id: Int) -> Request<[GiveSpeechPlainObject]> {
      return Request(query: "giveSpeeches/user/\(id)")
    }
  }

  init?(json: JSONDictionary) {
    guard
      let id = json["id"] as? Int,
      let title = json["title"] as? String,
      let description = json["description"] as? String,
      let status = json["status"] as? String
      else { return nil }

    self.id = id
    self.title = title
    self.description = description
    self.giveSpeechStatus = status
  }

}
