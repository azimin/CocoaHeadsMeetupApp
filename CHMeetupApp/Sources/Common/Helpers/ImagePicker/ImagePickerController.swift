//
//  ImagePickerController.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 27/04/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import MobileCoreServices

typealias ImagePickerDelegate = UINavigationControllerDelegate & UIImagePickerControllerDelegate

final class ImagePickerController {
  private let imagePicker = UIImagePickerController()
  private var isPhotoLibraryAvailable: Bool {
    return UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
  }

  weak var delegate: ImagePickerDelegate?

  init(delegate: ImagePickerDelegate) {
    self.delegate = delegate
  }

  func showPhotoLibrary(on viewController: UIViewController) {
    if !isPhotoLibraryAvailable {
      assertionFailure("You shoud request photo access before calling this method")
    }
    showSource(on: viewController, component: .photoLibrary)
  }

  private func showSource(on viewController: UIViewController, component: UIImagePickerControllerSourceType) {
    let type = kUTTypeImage as String // kUTTypeImage is `CFString`

    imagePicker.sourceType = component
    imagePicker.allowsEditing = true
    imagePicker.delegate = delegate
    if let availableTypes = UIImagePickerController.availableMediaTypes(for: component),
      availableTypes.contains(type) {
      imagePicker.mediaTypes = [type]
    }
    DispatchQueue.main.async {
      viewController.present(self.imagePicker, animated: true, completion: nil)
    }
  }

  static func showImagePicker<T: UIViewController>(on viewController: T) where T: ImagePickerDelegate {
    let source = ImagePickerController(delegate: viewController)
    source.showPhotoLibrary(on: viewController)
  }
}
