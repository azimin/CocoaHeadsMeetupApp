//
//  ProfileEditDisplayCollection.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 18/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProfileEditDisplayCollection: NSObject, DisplayCollection {

  class EditableField {
    var value: String
    var title: String
    var formatter: FormatterType?
    var isValid: (String) -> Bool
    var save: (String) -> Void

    init(value: String?,
         title: String,
         formatter: FormatterType? = nil,
         isValid: @escaping (String) -> Bool,
         save: @escaping (String) -> Void) {

      self.value = value ?? ""
      self.title = title
      self.formatter = formatter
      self.isValid = isValid
      self.save = save
    }
  }

  static var modelsForRegistration: [CellViewAnyModelType.Type] {
    return [ChooseProfilePhotoTableViewCellModel.self,
            EditableLabelTableViewModel.self]
  }

  enum `Type` {
    case userHeader
    case userEditableField
  }

  fileprivate var photoCell: ChooseProfilePhotoTableViewCell!
  fileprivate var sections: [Type] = [.userHeader, .userEditableField]

  var user: UserEntity! {
    didSet {
      var editableFields: [EditableField] = []

      let phone = EditableField(value: user.phone,
                                title: "Телефон".localized,
                                formatter: PhoneNumberFormatter(),
                                isValid: { phone -> Bool in
                                  if phone.isEmpty { return true }
                                  return StringValidation.isValid(string: phone, type: .phone)
      }, save: { [weak self] value in
        realmWrite {
          self?.user.phone = value
        }
      })

      let email = EditableField(value: user.email,
                                title: "Email".localized,
                                formatter: EmailFormatter(),
                                isValid: { email -> Bool in
                                  return StringValidation.isValid(string: email, type: .mail)
      }, save: { [weak self] value in
        realmWrite {
          self?.user.email = value
        }
      })

      let company = EditableField(value: user.company, title: "Компания".localized, isValid: { _ -> Bool in
        return true
      }, save: { [weak self] value in
        realmWrite {
          self?.user.company = value
        }
      })

      let position = EditableField(value: user.position, title: "Позиция".localized, isValid: { _ -> Bool in
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

      sections = [.userHeader]
      sections += Array(repeating: .userEditableField, count: editableFields.count)
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
    case .userEditableField:
      return 1
    }
  }

  func model(for indexPath: IndexPath) -> CellViewAnyModelType {
    switch sections[indexPath.section] {
    case .userHeader:
      return ChooseProfilePhotoTableViewCellModel(userEntity: user, delegate: self)

    case .userEditableField:
      guard let firstIndex = sections.index(of: .userEditableField) else {
        fatalError("No index for current section")
      }
      let field = editableFields[indexPath.section - firstIndex]
      return EditableLabelTableViewModel(description: field.value,
                                         placeholder: field.title,
                                         formatter: field.formatter,
                                         textFieldDelegate: self,
                                         valueChanged: { changedValue in
                                          field.value = changedValue
      })
    }
  }

}

extension ProfileEditDisplayCollection: ChooseProfilePhotoTableViewCellDelegate {
  func chooseProfilePhotoCellDidPressOnPhoto(_ cell: ChooseProfilePhotoTableViewCell) {
    photoCell = cell
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
    // TODO: - Give ability to cancel request
    let data = UIImagePNGRepresentation(image)
    if let data = data {
      let updateRequest = RequestPlainObject.Requests.updatePhoto(photo: data)
      SVProgressHUD.show()
      Server.standard.request(updateRequest) { response, _ in
        if let success = response?.success, success == true {
          let token = (UserPreferencesEntity.value.currentUser?.token)!
          ProfileController.updateUser(withToken: token, completion: { _ in })
          self.photoCell.mainButton.photoImageView?.image = image
        }
        SVProgressHUD.dismiss()
      }
    } else {
      assertionFailure("Image can't be parsed to data")
    }
  }

  func headerHeight(for section: Int) -> CGFloat {
    switch sections[section] {
    case .userEditableField:
      return 40
    case .userHeader:
      return 0
    }
  }

  func headerTitle(for section: Int) -> String {
    switch sections[section] {
    case .userHeader:
      return ""
    case .userEditableField:
      guard let firstIndex = sections.index(of: .userEditableField) else {
        fatalError("No index for current section")
      }
      let index = section - firstIndex
      return editableFields[index].title
    }
  }
}

extension ProfileEditDisplayCollection: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

extension ProfileEditDisplayCollection {

  var failedField: IndexPath? {
    for (index, field) in editableFields.enumerated() {
      if !field.isValid(field.value) {
        guard let firstIndex = sections.index(of: .userEditableField) else {
          fatalError("No index for current section")
        }
        return IndexPath(row: 0, section: firstIndex + index)
      }
    }
    return nil
  }

  func update() {
    for field in editableFields {
      if field.isValid(field.value) {
        field.save(field.value)
      }
    }
  }
}
