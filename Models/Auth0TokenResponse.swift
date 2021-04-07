//
//  Auth0TokenResponse.swift
//  ZipCheckout-iOS
//
//  Created by Scott Murray on 6/04/21.
//

import Foundation

public struct Auth0TokenResponse: Decodable {
  var access_token: String
  var scope: String
  var expires_in: Int
  var token_type: String
}
