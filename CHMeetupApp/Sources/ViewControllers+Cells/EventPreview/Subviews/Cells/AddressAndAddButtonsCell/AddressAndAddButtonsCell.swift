//
//  AdressAndAddButtonsCell.swift
//  CHMeetupApp
//
//  Created by Егор Петров on 28/02/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class AddressAndAddButtonsCell: UITableViewCell {

  var controller = UIViewController()

  @IBAction func showAdress(sender: UIButton) {
  }

  @IBAction func addToCalendar(sender: UIButton) {
    Importer.import(event: EventPO(), to: .calendar, completion: { Result in
      switch Result {
      case .success:
        ImportResultHandler.result(type: .success, in: self.controller)
      case .permissionError :
        ImportResultHandler.result(type: .permissionError, in: self.controller)
        print("Sorry")
      case .saveError:
        ImportResultHandler.result(type: .saveError, in: self.controller)
      }
    })
  }

  @IBAction func addToReminder(sender: UIButton) {
    Importer.import(event: EventPO(), to: .reminder, completion: { Result in
      switch Result {
        case .success:
          ImportResultHandler.result(type: .success, in: self.controller)
        case .permissionError :
          ImportResultHandler.result(type: .permissionError, in: self.controller)
        print("sorry")
        case .saveError:
          ImportResultHandler.result(type: .saveError, in: self.controller)
      }
    })
  }

  static var nib: UINib {
    return UINib(nibName: String(describing: self), bundle: nil)
  }

  static var identifier: String {
    return String(describing: self)
  }
}
