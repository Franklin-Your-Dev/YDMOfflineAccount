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
  
  var listItensOffiline = [
    ItensOffinlineAccount(
      icon: YDAssets.Images.store!,
      title: "suas compras nas lojas físicas",
      type: .store,
      new: false
    ),
    ItensOffinlineAccount(
      icon: YDAssets.Images.clipboard!,
      title: "seu histórico de dados informados nas lojas",
      type: .clipboard,
      new: false
    )
  ]
  
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
    buildList()
    setupCollectionView()
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
  
  func buildList() {
    
    if viewModel?.customerIdentifierEnabled ?? false {
      let customerIdentifier = ItensOffinlineAccount(
        icon: YDAssets.Images.qrCodeCard!,
        title: "identifique-se aqui e facilite suas compras nas lojas físicas :)",
        type: .customerIdentifier,
        new: viewModel?.flagNewCustomerIdentifierEnable ?? false
      )
      listItensOffiline.insert(customerIdentifier, at: 0)
    }
    
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
