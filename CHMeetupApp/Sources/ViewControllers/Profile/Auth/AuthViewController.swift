//
//  AuthViewController.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 22/02/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit
import SafariServices

class AuthViewController: UIViewController, ProfileHierarhyViewControllerType {

  @IBOutlet var authButtons: [UIButton]! {
    didSet {
      for button in authButtons {
        button.layer.cornerRadius = Constants.SystemSizes.cornerRadius
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.appFont(.gothamProMedium(size: 15))
      }
    }
  }

  @IBOutlet var infoLabel: UILabel! {
    didSet {
      infoLabel.font = UIFont.appFont(.systemFont(size: 15))
    }
  }

  var safariViewController: SFSafariViewController?
  var loggingApp: LoginType?

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Auth".localized
  }

  @IBAction func vkLoginButtonAction(_ sender: UIButton) {
    loginApp(at: .vk)
  }

  @IBAction func fbLoginButtonAction(_ sender: UIButton) {
    loginApp(at: .fb)
  }

  @IBAction func twLoginButtonAction(_ sender: UIButton) {
    loginApp(at: .twitter)
  }
}

// MARK: - Login actions
extension AuthViewController {

  func setupNotification() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(loggedIn(_:)),
                                           name: .CloseSafariViewControllerNotification,
                                           object: nil)
  }
  
  func loginApp(at type: LoginType) {
    loggingApp = type
    if type == .twitter {
      
      let url = URL(string: "tw\(Constants.Twitter.clientId)://success")!
      let twitter = Twitter(consumerKey: Constants.Twitter.key, consumerSecret: Constants.Twitter.secret)
      twitter.authorize(with: url, presentFrom: self, success: {[unowned self] token in
        DispatchQueue.main.async {
          self.hideSafariViewController()
          if let token = token {
            self.sendToken(token: token.key)
            LoginProcessController.isLogin = true
            self.profileNavigationController?.updateRootViewController()
          }
        }
      })
    } else {
      if !type.isAppExists {
        setupNotification()
        let url = type.urlAuth
        showSafariViewController(url: url)
      } else {
        let url = type.schemeAuth
        if let url = url {
          UIApplication.shared.open(url, options: [:])
        } else {
          assertionFailure("Error: you didn't recieve url from notification")
        }
      }
    }
  }

  func loggedIn(_ notification: Notification? = nil) {
    NotificationCenter.default.removeObserver(self)
    hideSafariViewController()
    guard let loggingApp = loggingApp,
      let notification = notification,
      let url = notification.object as? URL else {
      return
    }
    guard let token = loggingApp.token(from: url) else {
      return
    }
    sendToken(token: token)
    LoginProcessController.isLogin = true
    profileNavigationController?.updateRootViewController()
}

  func sendToken(token: String) {
    print(token)
    // TODO: sendToken (@mejl should do)
  }

}

// MARK: - Working with safariViewController
extension AuthViewController {
  func showSafariViewController(url: URL) {
    safariViewController = SFSafariViewController(url: url, entersReaderIfAvailable: true)
    self.present(safariViewController!, animated: true, completion: nil)
  }

  func hideSafariViewController() {
    if let safariViewController = safariViewController {
      if safariViewController.isViewLoaded {
        safariViewController.dismiss(animated: true, completion: nil)
      }
    }
  }
}
