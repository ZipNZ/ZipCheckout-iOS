//
//  CreateOrderRequest.swift
//  ZipCheckout-iOS
//
//  Created by Scott Murray on 6/04/21.
//

import Foundation

struct Order: Codable {
  let amount: Int
  let consumer: Consumer
  let billing, shipping: Ing
  let description: String
  let items: [Item]
  let merchant: Merchant
  let merchantReference: String
  let taxAmount, shippingAmount: Int

  enum CodingKeys: String, CodingKey {
    case amount, consumer, billing, shipping
    case description
    case items, merchant, merchantReference, taxAmount, shippingAmount
  }
}

struct Ing: Codable {
  let addressLine1, addressLine2, suburb, postcode: String
}

struct Consumer: Codable {
  let phoneNumber, givenNames, surname:String
  let email: String?
}

struct Item: Codable {
  let name, sku: String
  let quantity: Int
  let price: Double
  let merchantChannel: String
}

struct Merchant: Codable {
  let redirectConfirmURL, redirectCancelURL: String

  enum CodingKeys: String, CodingKey {
    case redirectConfirmURL = "redirectConfirmUrl"
    case redirectCancelURL = "redirectCancelUrl"
  }
}
