//
//  ImagePicker.swift
//  CHMeetupApp
//
//  Created by Michael Galperin on 03.03.17.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

final class ImagePicker {

  /// Presents ImagePickerViewController and returns selected image in callback
  ///
  /// - parameter controller: `UIViewController` for picker to be presented on
  /// - parameter photoSelectedBlock: callback with `UIImage`
  static func present(
    on controller: UIViewController,
    photoSelectedBlock: @escaping ImagePickerCompletion) {
    controller.requireAccess(to: .photosLibrary) { granted in
      if granted {
        let pickerViewController = ImagePickerViewController(photoSelectedBlock: photoSelectedBlock)
        let pickerNavigationController = UINavigationController(rootViewController: pickerViewController)
        DispatchQueue.main.async {
          controller.present(pickerNavigationController, animated: true, completion: nil)
        }
      }
    }
  }

}
