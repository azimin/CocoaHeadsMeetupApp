//
//  UserPO+Requests.swift
//  CHMeetupApp
//
//  Created by Sam on 28/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import Foundation

extension UserPO: POType {

  typealias RequestsEnum = Requests
  struct Requests {
    // Users list
    static var list: Request<[UserPO]> {
      return Request(query: "users")
    }

    // Authorization by social network
    static func auth(token: String, socialId: String) -> Request<UserPO> {
      return Request<UserPO>(query: "user/auth", method: .post)
    }

    // Example of custom parser
    static var listOfIds: Request<[UserPO]> {
      let parser = RequestContentParser<[UserPO]> { (jsonObject: Any) -> ([UserPO]?, ServerError?) in
        guard let json = jsonObject as? [JSONDictionary] else {
          return (nil, .wrongResponse)
        }
        let objects: [UserPO] = json.flatMap(UserPO.init(justId:))
        return (objects, nil)
      }

      return Request(query: "users", parser: parser)
    }
  }
}
