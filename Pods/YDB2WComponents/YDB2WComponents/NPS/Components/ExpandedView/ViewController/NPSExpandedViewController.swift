//
//  NPSExpandedViewController.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 18/10/21.
//

import UIKit
import YDB2WModels

public class YDNPSExpandedViewController: UIViewController {
  // MARK: Properties
  public weak var UIDelegate: YDNPSExpandedUIDelegate?
  public weak var actionDelegate: YDNPSExpandedActionDelegate?
  weak var spaceyViewModel: YDSpaceyViewModelDelegate?
  
  // MARK: Components
  let sendButton = YDWireButton(withTitle: "enviar avaliação")
  public var spaceyViewController: YDSpaceyViewController?
  let bottomShadowView = UIView()
  let shimmerView = YDNPSExpandedShimmerView()
  
  // MARK: View life cycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureBinds()
  }
  
  // MARK: Init
  public init(spaceyViewModel: YDSpaceyViewModelDelegate?) {
    super.init(nibName: nil, bundle: nil)
    self.spaceyViewModel = spaceyViewModel
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Public actions
public extension YDNPSExpandedViewController {
  func set(list: [YDSpaceyCommonStruct]) {
    spaceyViewController?.set(list: list)
  }
  
  func setSendButtonEnabled(_ enabled: Bool) {
    sendButton.setEnabled(enabled)
  }
}

// MARK: Actions
extension YDNPSExpandedViewController {
  @objc func onSendButtonAction(_ sender: UIButton) {
    actionDelegate?.onNPSSendButtonAction()
  }
}
