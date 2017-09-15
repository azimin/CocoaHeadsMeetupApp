//
//  GitHubResource.swift
//  CHMeetupApp
//
//  Created by Andrey Ostanin on 14/09/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import Foundation

final class GitHubResource: SocialResource {
	fileprivate static var state: String = ""

	fileprivate var token: String?
	fileprivate var secret: String?
	var appScheme: URL?

	var authURL: URL? {
		GitHubResource.state = "\(arc4random())"
		var authString = "https://github.com/login/oauth/authorize?client_id=\(Constants.GitHub.clientId)"
		authString += "&redirect_uri=\(Constants.GitHub.redirect)&scope=\(Constants.GitHub.scope)"
		authString += "&state=\(GitHubResource.state)"
		print(authString)
		return URL(string: authString)
	}

	func parameters(from url: URL) -> [String: String] {
		let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
		guard
			let state = components?.queryItems?.first(where: { $0.name == "state" })?.value,
			state == GitHubResource.state,
			let code = components?.queryItems?.first(where: { $0.name == "code" })?.value
		else { return [:] }
		return ["token": code, "secret": ""]
	}
}
