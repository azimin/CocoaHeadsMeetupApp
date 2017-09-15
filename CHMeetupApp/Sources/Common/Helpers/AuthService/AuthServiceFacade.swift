//
//  AuthServiceFacade.swift
//  CHMeetupApp
//
//  Created by Sam Mejlumyan on 25/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import SafariServices
import SVProgressHUD

final class AuthServiceFacade {
  fileprivate var safari: SFSafariViewController?
  fileprivate weak var currentViewController: UIViewController?
  fileprivate var loginCompletion: ((UserPlainObject?, Error?) -> Void)?
  fileprivate var currentService: AuthResourceType?

  enum AuthResourceType: String {
    case vk
    case fb
		case github
    case tw

    var identifier: String {
      return self.rawValue
    }

    var resource: SocialResource {
      switch self {
      case .vk:
        return VKResource()
      case .fb, .tw:
        return FBResource()
			case .github:
				return GitHubResource()
      }
    }

  }

  init() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(AuthServiceFacade.loggedIn(_:)),
                                           name: .CloseSafariViewControllerNotification,
                                           object: nil)
  }

  func login(with service: AuthResourceType,
             from view: UIViewController,
             completion: @escaping (UserPlainObject?, Error?) -> Void) {
    loginCompletion = completion
    currentViewController = view
    currentService = service

    let isLogged = LoginProcessController.isLogin
    if isLogged {
      completion(nil, nil)
    } else {
      guard let authURL = service.resource.authURL else {
        assertionFailure("Auth url error")
        return
      }

      if service.resource.appExists {
        UIApplication.shared.open(authURL)
      } else {
        showSafari(url: authURL)
      }

    }
  }

  @objc func loggedIn(_ notification: Notification? = nil) {
    hideSafari()
    guard
      let notification = notification,
      let url = notification.object as? URL
    else { return }

    let parameters = currentService?.resource.parameters(from: url)
    guard
        let token = parameters?["token"],
        let secret = parameters?["secret"],
        let social = currentService?.identifier
    else { return }

    SVProgressHUD.show()
    UIApplication.shared.beginIgnoringInteractionEvents()

    let authRequest = UserPlainObject.Requests.auth(token: token,
                                                    secret: secret,
                                                    socialId: social)
    Server.standard.request(authRequest) { user, error in
      guard let loginCompletion = self.loginCompletion else { return }
      SVProgressHUD.dismiss(completion: {
        UIApplication.shared.endIgnoringInteractionEvents()
      })

      if let error = error {
        loginCompletion(nil, error)
      } else {
        loginCompletion(user, nil)
      }
    }
  }

  /*
   * Present safari view controller to current view controller
   * Kirill Averyanov
   */

  fileprivate func showSafari(url: URL) {
    safari = SFSafariViewController(url: url, entersReaderIfAvailable: true)
    currentViewController?.present(safari!, animated: true, completion: nil)
  }

  fileprivate func hideSafari() {
    if let safari = safari, safari.isViewLoaded {
      safari.dismiss(animated: false, completion: nil)
    }
  }

}

extension Notification.Name {
  // swiftlint:disable:next line_length
  static let CloseSafariViewControllerNotification: Notification.Name = Notification.Name(rawValue: "CloseSafariViewControllerNotification")
}
