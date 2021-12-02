//
//  YDMStoreModeOfflineAccountViewController.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas on 12/01/21.
//

import UIKit

import YDB2WAssets
import YDExtensions
import YDB2WComponents
import YDB2WColors

class HomeViewController: UIViewController {
  // MARK: Variables
  
  var viewModel: HomeViewModelDelegate?
  var navBarShadowOff = true
  
  // MARK: Views
  @IBOutlet weak var shadowView: UIView! {
    didSet {
      shadowView.backgroundColor = .white
      shadowView.layer.zPosition = 5
    }
  }
  
  var collectionView: UICollectionView?
  
  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "meu perfil modo loja"
    navigationController?.navigationBar.barTintColor = .white
  
    createBackButton()
    setBinds()
    setupCollectionView()
    viewModel?.buildList()
    viewModel?.trackState()
  
  }
}

// MARK: Actions
extension HomeViewController {
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
    viewModel?.onExit()
  }
  
  func toggleNavShadow(_ show: Bool) {
    if show {
      UIView.animate(withDuration: 0.5) { [weak self] in
        self?.shadowView.layer.applyShadow()
      }
    } else {
      UIView.animate(withDuration: 0.5) { [weak self] in
        self?.shadowView.layer.shadowOpacity = 0
      }
    }
  }
}
