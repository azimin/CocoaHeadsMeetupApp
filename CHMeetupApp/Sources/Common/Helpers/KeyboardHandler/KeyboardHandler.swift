//
//  KeyboardHandler.swift
//  CHMeetupApp
//
//  Created by Michael Galperin on 23.02.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

var activeInputView: UIView?
var prevInputView: UIView?

protocol KeyboardHandlerDelegate: class {
  /// This function handles keyboard state changing
  ///
  /// - parameter input: Active input component - `UITextField` or `UITextView`
  /// - parameter state: Keyboard state -  .opened, .frameChanged, .hidden
  /// - parameter info: Keyboard appearance and size information
  ///
  func keyboardStateChanged(input: UIView?, state: KeyboardState, info: KeyboardInfo)
  func keyboardActiveInputViewChanged(input: UIView?, info: KeyboardInfo)
}

extension KeyboardHandlerDelegate {
  /// This function informs about changed input view without changing keyboard state
  /// - parameter input: Active input component - `UITextField` or `UITextView`
  /// - parameter info: Keyboard appearance and size information
  func keyboardActiveInputViewChanged(input: UIView?, info: KeyboardInfo) {}
}

enum KeyboardState: String { // String for rawValue while testing
  case opened, hidden, frameChanged
}

struct KeyboardInfo {
  let beginFrame: CGRect
  let endFrame: CGRect
  let duration: TimeInterval
  let curve: UIViewAnimationCurve

  func animate(_ animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
    let curveOption: UIViewAnimationOptions
    switch curve {
    case .linear:
      curveOption = .curveLinear
    case .easeIn:
      curveOption = .curveEaseIn
    case .easeOut:
      curveOption = .curveEaseOut
    case .easeInOut:
      curveOption = .curveEaseInOut
    }

    UIView.animate(withDuration: duration,
                   delay: 0,
                   options: [curveOption],
                   animations: animations,
                   completion: completion)
  }
}

/// Receives system notifications about keyboard appearance
///
/// How to use:
///   1) Subclass your controller from **KeyboardHandlerDelegate**
///   2) Set `keyboardDelegate` to self
///
class KeyboardHandler {

  weak var delegate: KeyboardHandlerDelegate?

  private enum VisibilityState {
    case hidden, visible, rotating
  }
  private var currentState: VisibilityState = .hidden {
    didSet {
      switch currentState {
        case .visible: wasVisible = false
        case .hidden: wasVisible = true
        default: break
      }
    }
  }

  init(delegate: KeyboardHandlerDelegate?) {
    self.delegate = delegate

    [
      NSNotification.Name.UIKeyboardWillShow: #selector(willShown(notification:)),
      NSNotification.Name.UIKeyboardWillHide: #selector(willHidden(notification:)),
      NSNotification.Name.UIKeyboardWillChangeFrame: #selector(willChangeFrame(notification:)),
      NSNotification.Name.UIApplicationWillChangeStatusBarOrientation: #selector(statusWillRotate(notification:)),
      NSNotification.Name.UIApplicationDidChangeStatusBarOrientation: #selector(statusDidRotate(notification:))
    ].forEach {
      NotificationCenter.default.addObserver(self, selector: $0.value, name: $0.key, object: nil)
    }
  }

  private var wasVisible = false // aka previousValue
  @objc func statusWillRotate(notification: Notification) {
    currentState = .rotating
  }

  @objc func statusDidRotate(notification: Notification) {
    currentState = wasVisible ? .hidden : .visible
  }

  @objc func willShown(notification: Notification) {
    guard let delegate = delegate else {
      return
    }
    if prevInputView != nil && activeInputView != nil && currentState == .visible {
      if prevInputView != activeInputView {
        getInfo(from: notification) { info in
          delegate.keyboardActiveInputViewChanged(input: activeInputView, info: info)
          prevInputView = activeInputView
          return
        }
      }
    }
    switch currentState {
      case .visible:
        return
    case .rotating:
        currentState = .visible
        return
      default: break
    }
    currentState = .visible
    getInfo(from: notification) { info in
      delegate.keyboardStateChanged(input: activeInputView, state: .opened, info: info)
    }
  }

  @objc func willHidden(notification: Notification) {
    if currentState == .rotating {
      return
    }
    currentState = .hidden
    prevInputView = nil
    getInfo(from: notification) { info in
      delegate?.keyboardStateChanged(input: activeInputView, state: .hidden, info: info)
    }
  }

  @objc func willChangeFrame(notification: Notification) {
    getInfo(from: notification) { info in
      if info.beginFrame.height != info.endFrame.height {
        delegate?.keyboardStateChanged(input: activeInputView, state: .frameChanged, info: info)
      }
    }
  }

  // ----- Private -----
  private func extractValues(from: [AnyHashable: Any]?) -> KeyboardInfo? {
    if let beginFrame = from?[UIKeyboardFrameBeginUserInfoKey] as? CGRect,
       let endFrame = from?[UIKeyboardFrameEndUserInfoKey] as? CGRect,
       let duration = from?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval,
       let curveRaw = from?[UIKeyboardAnimationCurveUserInfoKey] as? Int,
       let curve = UIViewAnimationCurve(rawValue: curveRaw) {
      return KeyboardInfo(beginFrame: beginFrame, endFrame: endFrame, duration: duration, curve: curve)
    }
    return nil
  }
  private func getInfo(from notification: Notification, completion: (KeyboardInfo) -> Void) {
    if let info = extractValues(from: notification.userInfo) {
      completion(info)
    }
  }

}
