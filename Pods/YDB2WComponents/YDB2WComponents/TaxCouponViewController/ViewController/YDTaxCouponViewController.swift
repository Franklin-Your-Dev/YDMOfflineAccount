//
//  YDTaxCouponView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 25/08/21.
//

import UIKit
import YDExtensions
import YDB2WModels
import YDB2WColors

public protocol YDTaxCouponDelegate: AnyObject {
  func shareButtonTrack()
}

public class YDTaxCouponViewController: UIViewController {
  // MARK: Properties
  var viewModel: YDTaxCouponViewModelDelegate?
  public weak var delegate: YDTaxCouponDelegate?
  public var taxCouponShareEnabled = false
  
  let addressPadding: CGFloat = 24
  let containerPadding: CGFloat = 16
  
  let labelsColor = YDColors.Gray.light
  let separatorViewColor = YDColors.Gray.disabled
  
  // MARK: Components
  var viewHeight: NSLayoutConstraint!
  let containerView = UIView()
  lazy var containerViewHeightConstraint: NSLayoutConstraint = {
    containerView.heightAnchor.constraint(equalToConstant: 480)
  }()
  
  let backButton = UIButton()
  
  let logoImageView = UIImageView()
  
  let storeNameLabel = UILabel()
  let storeAddressLabel = UILabel()
  
  let storeSeparatorView = UIView()
  
  let dateInfoView = YDTaxCouponInfoView(title: "Data")
  let storeInfoView = YDTaxCouponInfoView(title: "Loja")
  let PDVInfoView = YDTaxCouponInfoView(title: "PDV")
  let couponInfoView = YDTaxCouponInfoView(title: "Cupom(COO)")
  
  let taxCouponLabel = UILabel()
  let taxCouponLabelSeparatorView = UIView()
  
  let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()
  )
  lazy var collectionViewHeightConstraint: NSLayoutConstraint = {
    collectionView.heightAnchor.constraint(equalToConstant: 154)
  }()
  
  let collectionViewSeparatorView = UIView()
  
  let totalPriceContainerView = UIView()
  let totalLabel = UILabel()
  let totalValueLabel = UILabel()
  
  let shareButtonContainerView = UIView()
  let shareButton = UIButton()
  
  // MARK: Init
  public init(
    navigation: YDTaxCouponNavigationDelegate,
    order: YDOfflineOrdersOrder
  ) {
    super.init(nibName: nil, bundle: nil)
    
    viewModel = YDTaxCouponViewModel(navigation: navigation, order: order)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Life cicle
  public override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
}

// MARK: Actions
extension YDTaxCouponViewController {
  public func start() {
    getOrdersDetails()
    collectionView.reloadData()
    
    if !taxCouponShareEnabled {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.shareButtonContainerView.isHidden = true
      }
    }
  }
  
  @objc func onBackAction() {
    viewModel?.onExit()
  }
  
  @objc func onShareAction() {
    shareAction()
    delegate?.shareButtonTrack()
  }
  
  func getOrdersDetails() {
    let order = viewModel?.getOrderDetails()
    storeNameLabel.text = order?.formattedStoreName
    storeAddressLabel.text = order?.formattedAddress
    
    dateInfoView.configure(withValue: order?.formattedDate)
    
    if let storeId = order?.storeId {
      storeInfoView.configure(withValue: "\(storeId)")
    }
    
    if let pdv = order?.pdv {
      PDVInfoView.configure(withValue: "\(pdv)")
    }
    
    if let cupomId = order?.cupom {
      couponInfoView.configure(withValue: "\(cupomId)")
    }
    
    totalValueLabel.text = order?.formattedPrice
  }
}
