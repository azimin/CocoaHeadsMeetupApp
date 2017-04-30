//
//  TabBarViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 22/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class TabBarViewController: CustomTabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()

    tabBar.barTintColor = UIColor(.white)
    tabBar.isTranslucent = false
    tabBar.tintColor = UIColor(.black)

    let shadowView = ShadowView(frame: tabBar.frame)
    tabBar.addSubview(shadowView)

    // Query example

    Server.standard.request(SpeechContentPlainObject.Requests.contentsOnSpeech(with: 3)) { (contents, error) in
      if let error = error {
        print(error)
      }

      for content in contents ?? [] {
        print(content)
      }
    }

    Server.standard.request(SpeechPlainObject.Requests.speechesOnEvent(with: 2)) { speeches, error in
      if let error = error {
        print(error)
      }

      for speech in speeches ?? [] {
        print(speech)
      }
    }

    Server.standard.request(EventPlainObject.Requests.list) { events, error in
      if let error = error {
        print(error)
      }

      for event in events ?? [] {
        print(event.speakersPhotos)
      }
    }

    Server.standard.request(UserPlainObject.Requests.listOfIds) { users, error in
      if let error = error {
        print(error)
      }

      for user in users ?? [] {
        print(user)
      }
    }
  }
}
