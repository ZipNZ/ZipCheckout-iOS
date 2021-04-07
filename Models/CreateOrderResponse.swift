//
//  CreateOrderResponse.swift
//  ZipCheckout-iOS
//
//  Created by Scott Murray on 6/04/21.
//

import Foundation

struct CreateOrderResponse: Decodable {
  var token: String
  var expiryDateTime: String
  var redirectUrl: String
  var orderId: String
}
