//
//  LoadingAnimationService.swift
//  ZipCheckout-iOS
//
//  Created by Scott Murray on 21/05/21.
//

import Foundation
import UIKit

/// Service that handles the presentation and dismissal of a loading modal
class LoadingAnimationService {

  private var _viewContext: UIViewController?
  private var _animatingController: UIViewController

  init() {

    let loaderController = UIAlertController(
      title: nil, message: "Loading...", preferredStyle: .alert)

    let loadingIndicator = UIActivityIndicatorView(
      frame: CGRect(x: 10, y: 5, width: 50, height: 50))

    loadingIndicator.style = UIActivityIndicatorView.Style.large
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.startAnimating()

    loaderController.view.addSubview(loadingIndicator)

    _animatingController = loaderController
  }

  func addCurrentView(_ viewContext: UIViewController) {
    _viewContext = viewContext
  }

  func animate(_ animate: Bool) {

    guard let viewContext = _viewContext else {
      NSLog("view controller not set")
      return
    }

    if animate {
      if _animatingController.presentingViewController == nil {
        NSLog("Loading...")
        viewContext.present(_animatingController, animated: true, completion: nil)
      }
    } else {
      if _animatingController.presentingViewController != nil {
        NSLog("Finished loading...")
        viewContext.dismiss(animated: true, completion: nil)
      }
    }
  }
}
