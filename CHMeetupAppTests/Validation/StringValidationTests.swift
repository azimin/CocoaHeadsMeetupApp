//
//  StringValidationTests.swift
//  CHMeetupApp
//
//  Created by Andrey Konstantinov on 10/03/17.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import XCTest

final class StringValidationTests: XCTestCase {

  // MARK: - Mail

  func testMailTrue() {
    let mail = "cocoa@heads.ru"
    let isMail = StringValidation.isValid(string: mail, type: .mail)
    XCTAssertTrue(isMail)
  }

  func testMailFalseNoAtSymbol() {
    let mail = "gar.bage"
    let isMail = StringValidation.isValid(string: mail, type: .mail)
    XCTAssertFalse(isMail)
  }

  func testMailFalseNoAtSymbolManyDots() {
    let mail = "gar.ba.ge"
    let isMail = StringValidation.isValid(string: mail, type: .mail)
    XCTAssertFalse(isMail)
  }

  func testMailFalseNoDot() {
    let mail = "gar@bage"
    let isMail = StringValidation.isValid(string: mail, type: .mail)
    XCTAssertFalse(isMail)
  }

  func testMailFalseTooManyAtSymbols() {
    let mail = "gar@@ba.ge"
    let isMail = StringValidation.isValid(string: mail, type: .mail)
    XCTAssertFalse(isMail)
  }

  func testMailFalseTooManyDots() {
    let mail = "gar@ba..ge"
    let isMail = StringValidation.isValid(string: mail, type: .mail)
    XCTAssertFalse(isMail)
  }

  // MARK: - URL

  func testUrlTrue() {
    let url = "http://apple.com"
    let isURL = StringValidation.isValid(string: url, type: .url)
    XCTAssertTrue(isURL)
  }

  func testUrlTrueS() {
    let url = "https://apple.com"
    let isURL = StringValidation.isValid(string: url, type: .url)
    XCTAssertTrue(isURL)
  }

  func testUrlTrueEndSlash() {
    let url = "http://apple.com/"
    let isURL = StringValidation.isValid(string: url, type: .url)
    XCTAssertTrue(isURL)
  }

  func testUrlTrueWithUpperCasedScheme() {
    let url = "HTtps://discussions.apple.com/thread/2313061"
    let isURL = StringValidation.isValid(string: url, type: .url)
    XCTAssertTrue(isURL)
  }

  func testUrlTrueWithPath() {
    let url = "https://discussions.apple.com/thread/2313061"
    let isURL = StringValidation.isValid(string: url, type: .url)
    XCTAssertTrue(isURL)
  }

  func testUrlTrueWithNamedAnchor() {
    let url = "https://discussions.apple.com/thread/2313061#whatever"
    let isURL = StringValidation.isValid(string: url, type: .url)
    XCTAssertTrue(isURL)
  }

  func testUrlNoScheme() {
    let url = "apple.com"
    let isURL = StringValidation.isValid(string: url, type: .url)
    XCTAssertTrue(isURL)
  }

  func testWrongProtocol() {
    let url = "htpt://apple.com"
    let isURL = StringValidation.isValid(string: url, type: .url)
    XCTAssertFalse(isURL)
  }

  func testProtocolOnly() {
    let url = "http://"
    let isURL = StringValidation.isValid(string: url, type: .url)
    XCTAssertFalse(isURL)
  }

  func testProtolPlusDot() {
    let url = "http://."
    let isURL = StringValidation.isValid(string: url, type: .url)
    XCTAssertFalse(isURL)
  }

  func testProtolPlusDomain() {
    let url = "http://.com"
    let isURL = StringValidation.isValid(string: url, type: .url)
    XCTAssertFalse(isURL)
  }

  func testCyrillicUrl() {
    let url = "кирилл.рф"
    let isURL = StringValidation.isValid(string: url, type: .url)
    XCTAssertTrue(isURL)
  }

  // MARK: - Url With Type

  func testVKShortPathUrl() {
    let url = "vk.com/aa"
    let isURL = StringValidation.isValid(string: url, type: .urlWithPath)
    XCTAssertTrue(isURL)
  }

  func testUrlWithWWWInDomain() {
    let url = "http://www.vk.com/aa"
    let isURL = StringValidation.isValid(string: url, type: .urlWithPath)
    XCTAssertTrue(isURL)
  }

  func testUrlWithJustProfileName() {
    let url = "@login"
    let isURL = StringValidation.isValid(string: url, type: .urlWithPath)
    XCTAssertFalse(isURL)
  }

  func testUrlWithOneSymbolPath() {
    let url = "vk.com/#"
    let isURL = StringValidation.isValid(string: url, type: .urlWithPath)
    XCTAssertFalse(isURL)
  }

  func testUrlSocialNetworkWithNoPath() {
    let url = "http://VK.com/"
    let isURL = StringValidation.isValid(string: url, type: .urlWithPath)
    XCTAssertFalse(isURL)
  }

  func testPersonalUrlProjectSite() {
    let url = "8of.org"
    let isURL = StringValidation.isValid(string: url, type: .urlWithPath)
    XCTAssertTrue(isURL)
  }

}
