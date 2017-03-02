//
//  TextViewWithPlaceholder.swift
//  CHMeetupApp
//
//  Created by Maxim Globak on 28.02.17.
//  Copyright © 2017 CocoaHeads Comunity. All rights reserved.
//

import UIKit

class TextViewWithPlaceholder: UITextView {
  var placeholderTextView: UITextView! {
    didSet {
      placeholderTextView.backgroundColor = UIColor.clear
      placeholderTextView.font = self.font
      placeholderTextView.textColor = self.textColor
      placeholderTextView.isUserInteractionEnabled = false
      placeholderTextView.alpha = 0.3
      placeholderTextView.isEditable = false
      placeholderTextView.isSelectable = false
    }
  }

  var placeholder: String? {
    didSet {
        placeholderTextView.text = placeholder
    }
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    commonInit()
  }

  convenience init(frame: CGRect) {
    self.init(frame: frame)
    commonInit()
  }

  private func commonInit() {
    placeholderTextView = UITextView(frame: self.bounds)
    addSubview(placeholderTextView)
    setupConstraints()
    setupNotifications()
  }

  private func setupNotifications() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(TextViewWithPlaceholder.textViewDidChange),
                                           name: NSNotification.Name.UITextViewTextDidChange,
                                           object: nil)
  }

  @objc private func textViewDidChange() {
    let isHide = !self.text.isEmpty
    changeTheVisibilityOf(view: placeholderTextView, isHide: isHide)
  }

  private func changeTheVisibilityOf(view: UIView, isHide: Bool) {
    UIView.animate(withDuration: 0.2, animations: {
      view.alpha = isHide ? 0.0 : 0.3
    })
  }

  private func setupConstraints() {
    placeholderTextView.translatesAutoresizingMaskIntoConstraints = false
    placeholderTextView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    placeholderTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    placeholderTextView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    placeholderTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
  }
}
