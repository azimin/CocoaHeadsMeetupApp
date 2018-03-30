//
//  Sharing.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 14/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class Sharing {
  static func share(on viewController: UIViewController, text: String?, image: UIImage?, link: URL?) {
    var toShare = [Any]()
    if let text = text { toShare.append(text) }
    if let image = image { toShare.append(image) }
    if let link = link { toShare.append(link) }
    guard toShare.count > 0 else { return }
    let activityViewController = UIActivityViewController(activityItems: toShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = viewController.view
    viewController.present(activityViewController, animated: true, completion: nil)
  }
}
