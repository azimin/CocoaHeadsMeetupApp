//
//  UITableView+ShakeRow.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 07/05/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import AudioToolbox

extension UITableView {
  func shakeRow(_ indexPath: IndexPath) {
    let cell = self.cellForRow(at: indexPath)
    cell?.shake()
  }

  func failedShakeRow(_ indexPath: IndexPath) {
    self.shakeRow(indexPath)
    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
  }
}
