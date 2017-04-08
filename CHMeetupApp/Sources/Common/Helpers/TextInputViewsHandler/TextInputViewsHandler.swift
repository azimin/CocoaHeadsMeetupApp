//
//  TextInputViewsHandler.swift
//  CHMeetupApp
//
//  Created by Denis on 06.04.17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

final class TextInputViewsHandler<Identifier: Hashable>: NSObject, UITextFieldDelegate, UITextViewDelegate {

  typealias InputResponder = TextInputResponder
  typealias InputView = TextInputView
  typealias Input = (view: InputView, identifier: Identifier)
  typealias InputChangesBlock = (Input, TextInputChangeType) -> (Void)

  // MARK: - Properties

  fileprivate var inputs = [Input]()

  // MARK: - Public

  override init() {
    super.init()
    subscribeOnInputTextChanges()
  }
  var inputDidUpdate: InputChangesBlock?

  func add(_ textInputView: InputView, with identifier: Identifier) {
    if inputView(with: identifier) != nil {
      return
    }

    switch textInputView {
    case let .textField(value):
      value.delegate = self
    case let .textView(value):
      value.delegate = self
    }

    let input = (textInputView, identifier)
    inputs.append(input)
    inputDidUpdate?(input, .preparing)
  }

  func text(at identifier: Identifier) -> String? {
    let result = inputs.first { (input) -> Bool in
      return input.identifier == identifier
    }
    return result?.view.text
  }

  @discardableResult
  func move(to responder: InputResponder) -> Bool {

    guard let currentIndex = indexForCurrentResonder else {
      let view: UIView? = inputs.first?.view.value()
      view?.becomeFirstResponder()
      return true
    }

    var view: UIView?

    switch responder {
    case .first:
      view = inputView(for: 0)?.value()
    case .next:
      view = inputView(for: currentIndex + 1)?.value()
    case .previous:
      view = inputView(for: currentIndex - 1)?.value()
    case let .custom(inputView):
      view = inputView
    }

    if let view = view {
      return view.becomeFirstResponder()
    } else {
      return false
    }
  }

  // MARK: - UITextFieldDelegate

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    move(to: .next)
    return isLast(textField)
  }

  func handleTextFieldDidChange(notification: Notification) {
    guard let textfield = notification.object as? UITextField else { return }
    guard let input = input(for: textfield) else { return }

    inputDidUpdate?(input, .init(notification: notification))
  }

  func handleTextViewDidChange(notification: Notification) {
    guard let textfield = notification.object as? UITextField else { return }
    guard let input = input(for: textfield) else { return }

    inputDidUpdate?(input, .init(notification: notification))
  }

  // MARK: - Private

  private func subscribeOnInputTextChanges() {

    // Textfield & TextView
    let textFieldNotifications: [NSNotification.Name: Selector] = [
      .UITextFieldTextDidChange: #selector(handleTextFieldDidChange(notification:)),
      .UITextFieldTextDidEndEditing: #selector(handleTextFieldDidChange(notification:)),
      .UITextFieldTextDidBeginEditing: #selector(handleTextFieldDidChange(notification:)),
      .UITextViewTextDidChange: #selector(handleTextViewDidChange(notification:)),
      .UITextViewTextDidBeginEditing: #selector(handleTextViewDidChange(notification:)),
      .UITextViewTextDidEndEditing: #selector(handleTextViewDidChange(notification:))
    ]


    textFieldNotifications.forEach { (name, selector) in
      NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
  }
}

fileprivate extension TextInputViewsHandler {

  var indexForCurrentResonder: Int? {
    var result: Int?

    for input in inputs.enumerated() {
      let view: UIView = input.element.view.value()
      if view.isFirstResponder {
        result = input.offset
        break
      }
    }
    return result
  }

  func isLast(_ view: UIView) -> Bool {
    return inputs.last?.view.value() === view
  }

  func inputView(with identifier: Identifier) -> InputView? {
    let result = inputs.first { (addedInput) -> Bool in
      return addedInput.identifier == identifier
    }
    return result?.view
  }

  func inputView(for index: Int) -> InputView? {
    guard index > 0 else { return nil }
    guard index < inputs.count else { return nil }
    return inputs[index].view
  }

  func input<View: UIView>(for view: View) -> Input? {
    let result = inputs.first { (input) -> Bool in
      return view === input.view.value()
    }
    return result
  }
}

// MARK: - Nested

enum TextInputChangeType {
  case preparing
  case beginEditing
  case textDidChange
  case endEditing

  init(notification: Notification? = nil) {
    guard let notification = notification else {
      self = .preparing
      return
    }

    let notifications: [Notification.Name: TextInputChangeType] = [
      .UITextFieldTextDidChange: .textDidChange,
      .UITextFieldTextDidBeginEditing: .beginEditing,
      .UITextFieldTextDidEndEditing: .endEditing,
      .UITextViewTextDidChange: .textDidChange,
      .UITextViewTextDidBeginEditing: .beginEditing,
      .UITextViewTextDidEndEditing: .endEditing
    ]

    let notificationType = notifications.first { (inputChange) -> Bool in
        return inputChange.key == notification.name
    }?.value

    self = notificationType ?? .preparing
  }
}

enum TextInputView {
  case textField(UITextField)
  case textView(UITextView)

  func value<T>() -> T {
    switch self {
    case let .textField(input):
      return input as! T //swiftlint:disable:this force_cast
    case let .textView(input):
      return input as! T //swiftlint:disable:this force_cast
    }
  }

  var text: String? {
    switch self {
    case let .textField(input):
      return input.text
    case let .textView(input):
      return input.text
    }
  }
}

enum TextInputResponder {
  case first
  case next
  case previous
  case custom(UIView)
}
