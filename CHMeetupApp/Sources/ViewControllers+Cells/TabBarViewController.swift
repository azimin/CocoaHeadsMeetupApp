//
//  TabBarViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 22/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Query example
    Server.request(UserPO.Requests.list) { (users, error) in
      if let error = error {
        print(error)
      }

      for user in users ?? [] {
        print(user)
      }
    }

    Server.request(UserPO.Requests.auth(token: "", socialId: "")) { (user, error) in
      if let error = error {
        print(error)
      }

      print(user ?? "Nil user")
    }

    Server.request(UserPO.Requests.listOfIds) { (users, error) in
      if let error = error {
        print(error)
      }

      for user in users ?? [] {
        print(user)
      }
    }
  }
}
