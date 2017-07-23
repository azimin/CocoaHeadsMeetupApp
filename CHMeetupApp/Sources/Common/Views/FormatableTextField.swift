//
//  FormatableTextField.swift
//  CHMeetupApp
//
//  Created by Dmitriy Lis on 23/07/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class FormatableTextField: UITextField, UITextFieldDelegate {

  var formatter: FormatterType? = nil {
    didSet {
      if let formatter = formatter {
        keyboardType = formatter.keyboardType
      }
    }
  }

  weak private var _delegate: UITextFieldDelegate?

  override open var delegate: UITextFieldDelegate? {
    get {
      return _delegate
    }
    set {
      self._delegate = newValue
    }
  }

  override open var text: String? {
    set {
      if let formatter = formatter, newValue != nil {
        let formattedNumber = formatter.format(newValue! as String)
        super.text = formattedNumber
      } else {
        super.text = newValue
      }
    }
    get {
      return super.text
    }
  }

  // MARK: - Init

  override public init(frame: CGRect) {
    super.init(frame:frame)
    commonInit()
  }

  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    commonInit()
  }

  // MARK: - Private funcs

  private func commonInit() {
    super.delegate = self
  }

  private let nonNumericSet: NSCharacterSet = {
    var mutableSet = NSMutableCharacterSet.decimalDigit().inverted
    mutableSet.remove(charactersIn: "+＋")
    return mutableSet as NSCharacterSet
  }()

  private struct CursorPosition {
    let numberAfterCursor: String
    let repetitionCountFromEnd: Int
  }

  private func extractCursorPosition() -> CursorPosition? {
    var repetitionCountFromEnd = 0
    // Check that there is text in the UITextField
    guard let text = text, let selectedTextRange = selectedTextRange else {
      return nil
    }
    let textAsNSString = text as NSString
    let cursorEnd = offset(from: beginningOfDocument, to: selectedTextRange.end)
    // Look for the next valid number after the cursor, when found return a CursorPosition struct
    for i in cursorEnd ..< textAsNSString.length {
      let cursorRange = NSRange(location: i, length: 1)
      let candidateNumberAfterCursor: NSString = textAsNSString.substring(with: cursorRange) as NSString
      if candidateNumberAfterCursor.rangeOfCharacter(from: nonNumericSet as CharacterSet).location == NSNotFound {
        for j in cursorRange.location ..< textAsNSString.length {
          let candidateCharacter = textAsNSString.substring(with: NSRange(location: j, length: 1))
          if candidateCharacter == candidateNumberAfterCursor as String {
            repetitionCountFromEnd += 1
          }
        }
        return CursorPosition(numberAfterCursor: candidateNumberAfterCursor as String,
                              repetitionCountFromEnd: repetitionCountFromEnd)
      }
    }
    return nil
  }

  private func selectionRangeForNumberReplacement(textField: UITextField, formattedText: String) -> NSRange? {
    let textAsNSString = formattedText as NSString
    var countFromEnd = 0
    guard let cursorPosition = extractCursorPosition() else {
      return nil
    }

    for i in stride(from: (textAsNSString.length - 1), through: 0, by: -1) {
      let candidateRange = NSRange(location: i, length: 1)
      let candidateCharacter = textAsNSString.substring(with: candidateRange)
      if candidateCharacter == cursorPosition.numberAfterCursor {
        countFromEnd += 1
        if countFromEnd == cursorPosition.repetitionCountFromEnd {
          return candidateRange
        }
      }
    }

    return nil
  }

  // MARK: - Delegate funcs

  public func textField(_ textField: UITextField,
                        shouldChangeCharactersIn range: NSRange,
                        replacementString string: String) -> Bool {
    guard let text = text else {
      return false
    }

    // allow delegate to intervene
    guard _delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true else {
      return false
    }

    let textAsNSString = text as NSString
    let changedRange = textAsNSString.substring(with: range) as NSString
    let modifiedTextField = textAsNSString.replacingCharacters(in: range, with: string)

    let filteredCharacters = modifiedTextField.characters.filter {
      if let textField = textField as? FormatableTextField {
        return  String($0).rangeOfCharacter(from: textField.nonNumericSet as CharacterSet) == nil
      }
      return false
    }
    let rawNumberString = String(filteredCharacters)

    let formattedNationalNumber: String
    if let formatter = formatter {
      formattedNationalNumber = formatter.format(rawNumberString as String)
    } else {
      formattedNationalNumber = (rawNumberString as String)
    }
    var selectedTextRange: NSRange?

    let nonNumericRange = (changedRange.rangeOfCharacter(from: nonNumericSet as CharacterSet).location != NSNotFound)
    if range.length == 1 && string.isEmpty && nonNumericRange {
      selectedTextRange = selectionRangeForNumberReplacement(textField: textField, formattedText: modifiedTextField)
      textField.text = modifiedTextField
    } else {
      selectedTextRange = selectionRangeForNumberReplacement(textField: textField,
                                                             formattedText: formattedNationalNumber)
      textField.text = formattedNationalNumber
    }
    sendActions(for: .editingChanged)
    if let selectedTextRange = selectedTextRange,
      let selectionRangePosition = textField.position(from: beginningOfDocument, offset: selectedTextRange.location) {
      let selectionRange = textField.textRange(from: selectionRangePosition, to: selectionRangePosition)
      textField.selectedTextRange = selectionRange
    }
    return false
  }
}
