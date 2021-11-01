//
//  YDNeedHelpViewController.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 29/09/21.
//

import UIKit

class YDNeedHelpViewController: UIViewController {
  // MARK: Properties
  var viewModel: YDNeedHelpViewModelDelegate?
  var screenPadding: CGFloat = 24
  
  // MARK: Components
  let logoContainer = UIView()
  let logoImageView = UIImageView()
  
  let titleLabel = UILabel()
  let descriptionLabel = UILabel()
  
  let openFormButton = UIButton(type: .system)
  let backButton = YDWireButton(withTitle: "voltar para live")
  
  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
}

// MARK: Actions
extension YDNeedHelpViewController {
  @objc func onCloseAction() {
    viewModel?.onExit()
  }
  
  @objc func onOpenFormAction() {
    viewModel?.openForm()
  }
}
