//
//  NPSViewController.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 19/10/21.
//

import UIKit
import YDB2WComponents

class NPSViewController: UIViewController {
  // MARK: Properties
  var viewModel: NPSViewModelDelegate?
  
  // MARK: Components
  let shadowView = UIView()
  var npsView: YDNPSExpandedViewController?
  lazy var npsViewBottomConstraint: NSLayoutConstraint? = {
    guard let npsView = self.npsView else { return nil }
    
    let bottomConstraint = npsView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    return bottomConstraint
  }()
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureBinds()
    configureObservers()
    viewModel?.getSpacey()
  }
}

// MARK: Actions
extension NPSViewController {
  @objc func onBackAction(_ sender: UIButton) {
    viewModel?.goBack()
  }
}
