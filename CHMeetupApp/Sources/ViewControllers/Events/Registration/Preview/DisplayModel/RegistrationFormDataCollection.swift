//
//  RegistrationFormDataCollection.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 05.03.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class FormDisplayCollection: NSObject, DisplayCollection {
  static var modelsForRegistration: [CellViewAnyModelType.Type] {
    return [FormPlateTableViewCellModel.self]
  }

  init(formData: FormData) {
    self.formData = formData
  }

  var formData: FormData!

  var numberOfSections: Int {
    return formData.sections.count
  }

  func numberOfRows(in section: Int) -> Int {
    return formData.sections[section].fieldAnswers.count
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    let cellTitle = formData.sections[indexPath.section].fieldAnswers[indexPath.row].value
    return FormPlateTableViewCellModel(title: cellTitle)
  }

  func headerTitle(for section: Int) -> String {
    return formData.sections[section].name
  }
}
