//
//  ProfileEditDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 18/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class ProfileEditDisplayCollection: NSObject, DisplayCollection {

  class EditableField {
    var value: String
    var title: String
    var parse: (String) -> Bool
    var save: (String) -> Void

    init(value: String, title: String, parse: @escaping (String) -> Bool, save: @escaping (String) -> Void) {
      self.value = value
      self.title = title
      self.parse = parse
      self.save = save
    }
  }

  static var modelsForRegistration: [CellViewAnyModelType.Type] {
    return [ChooseProfilePhotoTableViewCellModel.self,
            EditableLabelTableViewModel.self]
  }

  enum `Type` {
    case userHeader
    case userEditableFields
  }

  fileprivate var sections: [Type] = [.userHeader, .userEditableFields]

  var user: UserEntity! {
    didSet {
      var editableFields: [EditableField] = []

      let phone = EditableField(value: user.phone ?? "", title: "Телефон".localized, parse: { _ -> Bool in
        return true
      }, save: { [weak self] value in
        realmWrite {
          self?.user.phone = value
        }
      })

      let email = EditableField(value: user.email, title: "Email".localized, parse: { _ -> Bool in
        return true
      }, save: { [weak self] value in
        realmWrite {
          self?.user.email = value
        }
      })

      let company = EditableField(value: user.company ?? "", title: "Компания".localized, parse: { _ -> Bool in
        return true
      }, save: { [weak self] value in
        realmWrite {
          self?.user.company = value
        }
      })

      let position = EditableField(value: user.position ?? "", title: "Позиция".localized, parse: { _ -> Bool in
        return true
      }, save: { [weak self] value in
        realmWrite {
          self?.user.position = value
        }
      })

      editableFields.append(phone)
      editableFields.append(email)
      editableFields.append(company)
      editableFields.append(position)
      self.editableFields = editableFields
    }
  }

  var editableFields: [EditableField]!

  weak var delegate: ProfileHierarhyViewControllerType?

  var numberOfSections: Int {
    return sections.count
  }

  func numberOfRows(in section: Int) -> Int {
    switch sections[section] {
    case .userHeader:
      return 1
    case .userEditableFields:
      return editableFields.count
    }
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    switch sections[indexPath.section] {
    case .userHeader:
      return ChooseProfilePhotoTableViewCellModel(userEntity: user, delegate: self)

    case .userEditableFields:
      let field = editableFields[indexPath.row]
      return EditableLabelTableViewModel(description: field.value,
                                         placeholder: field.title,
                                         textFieldDelegate: self,
                                         valueChanged: { changedValue in
                                          field.value = changedValue
      })
    }
  }

}

extension ProfileEditDisplayCollection: ChooseProfilePhotoTableViewCellDelegate {
  func chooseProfilePhotoCellDidPressOnPhoto(_ cell: ChooseProfilePhotoTableViewCell) {
    let viewController = delegate?.getViewController()
    if let viewController = viewController as? ProfileEditViewController {
      PermissionsManager.requireAccess(from: viewController, to: .photosLibrary,
                                       completion: { _ in
                                        ImagePickerController.showImagePicker(on: viewController)
      })
    }
  }

  func didReciveMedia(_ picker: UIImagePickerController, info: [String : Any]) {
    if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
      changeCheckedImage(image: image)
    }
    picker.dismiss(animated: true, completion: nil)
  }

  func changeCheckedImage(image: UIImage) {
    // TODO: - Load image
  }
}

extension ProfileEditDisplayCollection: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return true
  }
}

extension ProfileEditDisplayCollection {
    func update() {
        for field in editableFields {
            if field.parse(field.value) {
                field.save(field.value)
            }
        }
    }
}
