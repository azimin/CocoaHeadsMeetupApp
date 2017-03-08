//
//  TabBarItemView.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 08/03/2017.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class TabBarItemView: CustomTabBarItemView {

  @IBOutlet var imageView: UIImageView!
  @IBOutlet var titleLabel: UILabel! {
    didSet {
      titleLabel.font = UIFont.appFont(.systemFont(size: 10))
    }
  }

  enum `Type` {
    case main
    case past
    case profile

    var icon: UIImage {
      var image: UIImage
      switch self {
      case .main:
        image = #imageLiteral(resourceName: "img_tab-bar_future")
      case .past:
        image = #imageLiteral(resourceName: "img_tab-bar_past")
      case .profile:
        image = #imageLiteral(resourceName: "img_tab-bar_profile")
      }
      return image.imageWithTemplateRendingMode
    }

    var title: String {
      switch self {
      case .main:
        return "Главный".localized
      case .past:
        return "Прошедшие".localized
      case .profile:
        return "Профиль".localized
      }
    }
  }

  enum State {
    case selected
    case unselected

    var color: UIColor {
      switch self {
      case .selected:
        return UIColor(.red)
      case .unselected:
        return UIColor(.grey)
      }
    }
  }

  private(set) var type: Type = .main {
    didSet {
      updateType()
    }
  }

  private(set) var state: State = .unselected {
    didSet {
      updateState()
    }
  }

  static func create(with type: Type) -> TabBarItemView {
    let cell = loadViewFromNib()
    cell.type = type
    return cell
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    state = selected ? .selected : .unselected
  }

  private func updateState() {
    imageView.tintColor = state.color
    titleLabel.textColor = state.color
  }

  private func updateType() {
    imageView.image = type.icon
    titleLabel.text = type.title
  }
}
