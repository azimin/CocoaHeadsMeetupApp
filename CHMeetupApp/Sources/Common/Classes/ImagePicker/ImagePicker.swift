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
        let vc = ImagePickerViewController(photoSelectedBlock: photoSelectedBlock)
        let nav = UINavigationController(rootViewController: vc)
        DispatchQueue.main.async {
          controller.present(nav, animated: true, completion: nil)
        }
      }
    }
  }

}
