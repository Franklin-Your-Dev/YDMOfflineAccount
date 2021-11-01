//
//  YDMFindStorePreStartViewController.swift
//  YDMFindStore
//
//  Created by Douglas on 09/01/21.
//

import UIKit

import YDB2WAssets
import YDLocationModule

class YDMFindStorePreStartViewController: UIViewController {
  // MARK: Properties
  var viewModel: YDMFindStorePreStartViewModelDelegate?
  
  // MARK: IBOutlets
  @IBOutlet weak var navBarView: UIView! {
    didSet {
      navBarView.backgroundColor = .clear
    }
  }
  
  @IBOutlet weak var backButton: UIButton! {
    didSet {
      backButton.layer.cornerRadius = backButton.frame.height / 2
      backButton.setImage(YDAssets.Icons.leftArrow, for: .normal)
    }
  }
  
  @IBOutlet weak var permissionView: UIView! {
    didSet {
      permissionView.backgroundColor = .clear
    }
  }
  
  @IBOutlet weak var iconImageView: UIImageView! {
    didSet {
      iconImageView.image = YDAssets.Icons.map
    }
  }
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var actionButton: UIButton! {
    didSet {
      actionButton.layer.borderWidth = 1
      actionButton.layer.borderColor = UIColor.white.cgColor
      actionButton.layer.cornerRadius = 4
    }
  }
  
  @IBOutlet weak var loadingView: UIView! {
    didSet {
      loadingView.backgroundColor = .clear
    }
  }
  
  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let image = YDAssets.Images.map {
      view.backgroundColor = UIColor(patternImage: image)
    }
    
    setBinds()
    viewModel?.getCurrentLocation()
  }
  
  // MARK: IBActions
  @IBAction func onBackAction(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func onButtonAction(_ sender: UIButton) {
    viewModel?.openButtonAction()
  }
}

// MARK: Binds
extension YDMFindStorePreStartViewController {
  func setBinds() {
    viewModel?.showPermission.bind { [weak self] show in
      guard let self = self else { return }
      
      UIView.animate(withDuration: 0.3) {
        self.permissionView.isHidden = !show
        self.loadingView.isHidden = show
      }
    }
  }
}
