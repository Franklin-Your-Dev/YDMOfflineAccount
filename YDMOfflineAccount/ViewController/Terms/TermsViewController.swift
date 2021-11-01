//
//  TermsViewController.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 02/02/21.
//

import UIKit

import YDB2WAssets
import YDExtensions

class TermsViewController: UIViewController, UITextViewDelegate {
  // MARK: Properties
  var viewModel: TermsViewModelDelegate?

  // MARK: IBOutlets
  @IBOutlet weak var separatorView: UIView!

  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "política de privacidade"

    createBackButton()
    configureBinds()

    viewModel?.getCustomView()
  }
}

// MARK: Actions
extension TermsViewController {
  func createBackButton() {
    let backButtonView = UIButton()
    backButtonView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    backButtonView.layer.cornerRadius = 16
    backButtonView.layer.applyShadow()
    backButtonView.backgroundColor = .white
    backButtonView.setImage(YDAssets.Icons.leftArrow, for: .normal)
    backButtonView.addTarget(self, action: #selector(onBackAction), for: .touchUpInside)

    let backButton = UIBarButtonItem()
    backButton.customView = backButtonView

    navigationItem.leftBarButtonItem = backButton
  }

  @objc func onBackAction(_ sender: UIButton) {
    viewModel?.onBack()
  }
  
  func attachCustomView(_ customView: UIView) {
    view.addSubview(customView)
    
    customView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      customView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
      customView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      customView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      customView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}
