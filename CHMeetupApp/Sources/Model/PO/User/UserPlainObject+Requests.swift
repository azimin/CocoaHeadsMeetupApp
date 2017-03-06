//
//  UserPlainObject+Requests.swift
//  CHMeetupApp
//
//  Created by Sam on 28/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation
import RealmSwift

extension UserPlainObject: PlainObjectType {

  struct Requests {
    // Users list
    static var list: Request<[UserPlainObject]> {
      return Request(query: "users")
    }

    // Authorization by social network
    static func auth(token: String, socialId: String) -> Request<UserPlainObject> {
      return Request<UserPlainObject>(query: "user/auth", method: .post)
    }

    // Example of custom parser
    static var listOfIds: Request<[UserPlainObject]> {
      let parser = RequestContentParser<[UserPlainObject]> { (jsonObject: Any) -> ([UserPlainObject]?, ServerError?) in
        guard let json = jsonObject as? [JSONDictionary] else {
          return (nil, .wrongResponse)
        }
        let objects: [UserPlainObject] = json.flatMap(UserPlainObject.init(justId:))
        return (objects, nil)
      }

      return Request(query: "users", parser: parser)
    }
  }
}
