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
  let sendButton = YDButton(withTitle: "enviar avaliação")
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
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.spaceyViewController?.view.isHidden = true
      self.shimmerView.isHidden = false
      self.shimmerView.startShimmers()
      
      self.spaceyViewController?.set(list: list)
      
      let time: Double = Double(list.count)
      Timer.scheduledTimer(
        withTimeInterval: 0.4 * time,
        repeats: false
      ) { _ in
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          self.spaceyViewController?.view.isHidden = false
          self.shimmerView.isHidden = true
          self.shimmerView.stopShimmers()
        }
      }
    }
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
