//
//  Auth0TokenRequest.swift
//  ZipCheckout-iOS
//
//  Created by Scott Murray on 6/04/21.
//

import Foundation

public struct Auth0TokenRequest: Codable {
  var client_id: String
  var client_secret: String
  var audience: String
  var grant_type: String

  init(_ clientId: String, _ clientSecret: String, _ audience: String, _ grantType: String) {
    self.client_id = clientId
    self.client_secret = clientSecret
    self.audience = audience
    self.grant_type = grantType
  }
}
