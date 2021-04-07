//
//  ViewController.swift
//  ZipCheckout-iOS
//
//  Created by Scott Murray on 6/04/21.
//

import UIKit

extension CheckoutController: ZipWebViewRedirectProtocol {
  func onCompletion() {
    DispatchQueue.main.async {
      // create the alert
      let alert = UIAlertController(
        title: "Order Status", message: self.completionStatus, preferredStyle: .alert)

      // add an action (button)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

      // show the alert
      self.present(alert, animated: true, completion: nil)
    }
  }
}

class CheckoutController: UIViewController {

  @IBOutlet weak var auth0Domain: UITextField!
  @IBOutlet weak var merchantClientId: UITextField!
  @IBOutlet weak var merchantClientSecret: UITextField!
  @IBOutlet weak var itemName: UITextField!
  @IBOutlet weak var orderAmount: UITextField!
  @IBOutlet weak var audience: UITextField!

  var completionStatus: String = "Incomplete"

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  @IBAction func startCheckout(_ sender: Any) {
    let checkout = Checkout(
      merchantClientId.text!, merchantClientSecret.text!,
      auth0Domain.text!, audience.text!, Int(orderAmount.text!)!, itemName.text!)

    checkout.startCheckout {
      redirect in
      do {
        DispatchQueue.main.async {
          let zipWebViewController =
            self.storyboard?.instantiateViewController(withIdentifier: "zipWebViewController")
            as! ZipWebViewController
          zipWebViewController.checkoutUrl = redirect.redirectUrl
          zipWebViewController.successRedirect = redirect.successUrl
          zipWebViewController.failureRedirect = redirect.failureUrl
          zipWebViewController.webviewProtocol = self
          self.present(zipWebViewController, animated: true, completion: nil)
        }
      }
    }
  }
}
