//
//  UITableView+ShakeSection.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 15/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import AudioToolbox

extension UITableView {
  func shakeSection(_ section: Int) {
    let cells = self.visibleCells

    let sectionHeaderView = self.headerView(forSection: section)
    if let headerView = sectionHeaderView {
      headerView.shake()
    }
    for cell in cells {
      let cellIndexPath = self.indexPath(for: cell)
      if let currentSection = cellIndexPath?.section, currentSection == section {
        cell.shake()
      }
    }
  }

  func failedShakeSection(_ section: Int) {
    self.shakeSection(section)
    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
  }
}
