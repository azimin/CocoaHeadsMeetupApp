//
//  ProfileEditInteractor.swift
//  CHMeetupApp
//
//  Created by Dmitriy Antyshev on 24.07.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

class ProfileEditInteractor {

  func cancelUploadPhoto() {
    Server.standard.obtainDataTaskWithIdentifier("user/update_photo") { (dataTask) in
      Server.standard.cancelDataTask(dataTask)
    }
  }
}
