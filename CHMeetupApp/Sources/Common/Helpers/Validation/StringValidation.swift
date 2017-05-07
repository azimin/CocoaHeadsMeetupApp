//
//  StringValidation.swift
//  CHMeetupApp
//
//  Created by Andrey Konstantinov on 10/03/17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

final class StringValidation {

  enum `Type` {
    case mail, url, urlWithPath, phone
  }

  /// Domains to check for .urlWithPath type
  private static let domainsToCheckPath: Set<String> = Set(["github", "facebook", "vk", "twitter", "linkedin"])

  static func isValid(string: String, type: Type) -> Bool {
    switch type {
    case .mail:
      return isMail(string)
    case .phone:
      return isPhone(string)
    case .url:
      return isURL(string)
    case .urlWithPath:
      return isUrlWIthType(string)
    }
  }

  // MARK: - Private

  private static func isMail(_ string: String) -> Bool {
    let format = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let predicate = NSPredicate(format: "SELF MATCHES %@", format)
    return predicate.evaluate(with: string) && !string.contains("..") // NOT contains two dots in a row
  }

  private static func isPhone(_ string: String) -> Bool {
    let chars = CharacterSet.decimalDigits.inverted
    let components = string.components(separatedBy: chars)
    return components.count == 1
  }

  private static func isURL(_ string: String) -> Bool {
    guard let url = url(from: string) else { return false }
    return isURL(url)
  }

  private static func isUrlWIthType(_ string: String) -> Bool {
    guard let url = url(from: string),
      isURL(url),
      let host = url.host
    else { return false }
    // If url domain is one of known social networks - check url pathes
    if domainsToCheckPath.contains(domainFrom(host: host)) {
      return !url.pathComponents
        .filter({ $0.characters.count > 1 })
        .isEmpty
    }
    return true
  }

  // MARK: - Helpers

  private static func isURL(_ url: URL) -> Bool {
    guard let host = url.host
    else { return false }
    return host.components(separatedBy: ".")
      .filter({ !$0.isEmpty })
      .count > 1
  }

  /// Create URL with protocol.
  /// Even if original string didn't have one.
  /// Falls if string is empty or contains 'illegal' characters
  private static func url(from string: String) -> URL? {
    if string.isEmpty {
      return nil
    }
    // Non-ASCII characters (and many special characters) need to encoded
    guard let lowercasedString = string.localizedLowercase
      .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    else { return nil }
    // Check if string has protocol
    let hasProtocol = lowercasedString.hasPrefix("http://") || lowercasedString.hasPrefix("https://")
    // Add protocol if needed
    let stringWithProtocol = hasProtocol ? lowercasedString : "http://".appending(lowercasedString)
    // Let Apple handle 'illegal characters' checks and empty string check
    return URL(string: stringWithProtocol)
  }

  /// Get first (counting from the left) subdomain from host
  ///
  /// - Parameter host: looks like 'apple.com, or 'www.github.com.'
  /// - Returns: subdomain or empty string
  private static func domainFrom(host: String) -> String {
    return host.components(separatedBy: ".")
      .filter({ !$0.isEmpty && $0 != "www" })
      .first ?? ""
  }
}
