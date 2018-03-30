//
//  PlateTableViewCell+AutomaticDetection.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 12/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

extension PlateTableViewCell {

  // Settings `shouldHaveVerticalMargin` to false
  func drawCorner(in tableView: UITableView, indexPath: IndexPath) {

    shouldHaveVerticalMargin = false

    let numberOfRowsInSection = tableView.numberOfRows(inSection: indexPath.section)
    if indexPath.row == 0 && numberOfRowsInSection == 1 {
      roundType = .all
    } else if indexPath.row == 0 {
      roundType = .top
    } else if indexPath.row == numberOfRowsInSection - 1 {
      roundType = .bottom
    } else {
      roundType = .none
    }
  }
}
