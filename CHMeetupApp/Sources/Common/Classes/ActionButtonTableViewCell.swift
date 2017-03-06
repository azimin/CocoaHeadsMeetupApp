//
//  ActionButtonTableViewCell.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 04/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class ActionButtonTableViewCell: UITableViewCell {

  @IBAction func buttonWasTupped( sender: UIButton) {
    actionByTap?(self)
  }
  var actionByTap: ((ActionButtonTableViewCell) -> Void)?
}

extension ActionButtonTableViewCell {

  enum ActionType {
    case addToCalendar
    case addToReminder
    case address
    case join
  }

  static func identifier(for type: ActionType) -> String {
    switch type {
    case .addToCalendar:
      return String(describing: self) + "AddToCalendar"
    case .addToReminder:
      return String(describing: self) + "AddToReminder"
    case .address:
      return String(describing: self) + "Address"
    case .join:
      return String(describing: self) + "Join"
    }
  }

  static func nib(for type: ActionType) -> UINib? {
    switch type {
    case .addToCalendar:
      return UINib(nibName: "AddToCalendarButtonTableViewCell", bundle: nil)
    case .addToReminder:
      return UINib(nibName: "AddToReminderButtonTableViewCell", bundle: nil)
    case .address:
      return UINib(nibName: "AddressButtonTableViewCell", bundle: nil)
    case .join:
      return UINib(nibName: "JoinButtonTableViewCell", bundle: nil)
    }
  }
}
