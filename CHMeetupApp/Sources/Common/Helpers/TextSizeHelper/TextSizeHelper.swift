//
//  TextSizeHelper.swift
//  CHMeetupApp
//
//  Created by Kirill Averyanov on 02/05/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class TextFrameAttributes {
  // Basic info
  fileprivate var width: CGFloat = 0
  fileprivate var string: String?
  fileprivate var attributedString: NSAttributedString?

  // Text Info
  var attributes: [NSAttributedStringKey: AnyObject] = [:]
  var lineBreakingMode: NSLineBreakMode = NSLineBreakMode.byWordWrapping {
    didSet {
      let paragraph = NSMutableParagraphStyle()
      paragraph.lineBreakMode = lineBreakingMode
      attributes[NSAttributedStringKey.paragraphStyle] = paragraph
    }
  }

  init(string: String) {
    self.string = string
  }

  init(string: String, font: UIFont) {
    self.string = string
    self.attributes = [NSAttributedStringKey.font: font]
  }

  init(string: String, width: CGFloat) {
    self.string = string
    self.width = width
    self.attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
  }

  init(string: String, width: CGFloat, font: UIFont) {
    self.string = string
    self.width = width
    self.attributes = [NSAttributedStringKey.font: font]
  }

  init(attributedString: NSAttributedString) {
    self.attributedString = attributedString
  }

  init(attributedString: NSAttributedString, width: CGFloat) {
    self.attributedString = attributedString
    self.width = width
  }

  var textWidth: CGFloat {
    return TextFrame(attributes: self).width
  }

  var textHeight: CGFloat {
    return TextFrame(attributes: self).height
  }
}

fileprivate final class TextFrame: NSObject {
  private let attributes: TextFrameAttributes
  private(set) var width: CGFloat = 0
  private(set) var height: CGFloat = 0

  init(attributes: TextFrameAttributes) {
    self.attributes = attributes
    super.init()
    self.calculate()
  }

  private func calculate() {
    let sizeForHeight = CGSize(width: attributes.width - 2, height: CGFloat.greatestFiniteMagnitude)
    let sizeForWidth = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)

    if let string = attributes.string {
      height = (string as NSString).boundingRect(with: sizeForHeight,
                                                 options: .usesLineFragmentOrigin,
                                                 attributes: attributes.attributes,
                                                 context: nil).height + 2
      width = (string as NSString).boundingRect(with: sizeForWidth,
                                                options: .usesLineFragmentOrigin,
                                                attributes: attributes.attributes,
                                                context: nil).width + 2
    } else if let attributedString = attributes.attributedString {
      height = attributedString.boundingRect(with: sizeForHeight,
                                             options: [.usesLineFragmentOrigin, .usesFontLeading],
                                             context: nil).height + 1
      width = attributedString.boundingRect(with: sizeForWidth,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            context: nil).width + 1
    }
  }
}
