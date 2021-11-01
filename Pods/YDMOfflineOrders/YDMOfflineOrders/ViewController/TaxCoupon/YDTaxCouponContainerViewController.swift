//
//  YDTaxCouponContainerViewController.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 26/08/21.
//

import UIKit
import YDB2WModels
import YDB2WComponents
import YDB2WIntegration

public class YDTaxCouponContainerViewController: UIViewController {
  // MARK: Properties
  let order: YDOfflineOrdersOrder
  var taxCouponViewController: YDTaxCouponViewController?
  var taxCouponShareEnabled: Bool
  
  // MARK: Components
  let containerView = UIView()
  
  // MARK: Init
  init(order: YDOfflineOrdersOrder, taxCouponShareEnabled: Bool = false) {
    self.order = order
    self.taxCouponShareEnabled = taxCouponShareEnabled
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Life cycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    attachTaxCouponView()
    
    taxCouponViewController?.taxCouponShareEnabled = taxCouponShareEnabled
    taxCouponViewController?.start()
    
    trackEvent(.taxCoupon, ofType: .state)
  }
}

// MARK: Actions
extension YDTaxCouponContainerViewController {
  func attachTaxCouponView() {
    let vc = YDTaxCouponViewController(navigation: self, order: order)
    taxCouponViewController = vc
    
    vc.willMove(toParent: self)
    
    addChild(vc)
    
    containerView.addSubview(vc.view)
    vc.view.bindFrame(toView: containerView)
    
    vc.didMove(toParent: self)
    
    taxCouponViewController?.delegate = self
  }
  
  func trackEvent(
    _ name: TrackEvents,
    ofType type: TrackType,
    withParameters parameters: [String: Any]? = nil
  ) {
    YDIntegrationHelper.shared.trackEvent(
      withName: name,
      ofType: type,
      withParameters: parameters
    )
  }
}

// MARK: Tax Coupon Navigation
extension YDTaxCouponContainerViewController: YDTaxCouponNavigationDelegate {
  public func onTaxCouponExit() {
    dismiss(animated: true)
  }
}

// MARK: Tax Coupon Delegate
extension YDTaxCouponContainerViewController: YDTaxCouponDelegate {
  public func shareButtonTrack() {
    let parameters = TrackEvents.taxCoupon.parameters(body: [:])
    trackEvent(.taxCoupon, ofType: .action, withParameters: parameters)
  }
}
