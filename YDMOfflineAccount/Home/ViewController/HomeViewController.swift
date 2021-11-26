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

enum ItensOffilineAccountEnum {
  case store
  case clipboard
}

class ItensOffinlineAccount {
  let icon: UIImage
  let title: String
  let type: ItensOffilineAccountEnum
  
  init(icon: UIImage, title: String, type: ItensOffilineAccountEnum) {
    self.icon = icon
    self.title = title
    self.type = type
  }
}


class HomeViewController: UIViewController {
  // MARK: Properties
  var viewModel: HomeViewModelDelegate?
  var navBarShadowOff = true
  
  @IBOutlet weak var shadowView: UIView! {
    didSet {
      shadowView.backgroundColor = .white
      shadowView.layer.zPosition = 5
    }
  }
  
  var collectionView: UICollectionView?
  
  var listItensOffiline = [
    ItensOffinlineAccount(
      icon: YDAssets.Images.store!,
      title: "suas compras nas lojas físicas",
      type: .store
    ),
    ItensOffinlineAccount(
      icon: YDAssets.Images.clipboard!,
      title: "seu histórico de dados informados nas lojas",
      type: .clipboard
    )
  ]
  
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
    
  }
  
  //  @objc func onCardAction(_ sender: UIGestureRecognizer) {
  //    guard let tag = sender.view?.tag else { return }
  //
  //    //
  //    viewModel?.onCard(tag: tag)
  //  }
  
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


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func setupCollectionView() {
    
    let layout  = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    collectionView!.register(HomeViewCell.self,
                             forCellWithReuseIdentifier: HomeViewCell.identifierCell)
    
    collectionView?.register(HomeHeaderViewCell.self,
                             forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                             withReuseIdentifier: HomeHeaderViewCell.identifierCell)
    
    collectionView!.delegate = self
    collectionView!.dataSource = self
    collectionView!.backgroundColor = .red
    
    self.view.addSubview(collectionView!)
    
    collectionView?.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      collectionView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      collectionView!.topAnchor.constraint(equalTo: self.view.topAnchor),
      collectionView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    ])
    
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return listItensOffiline.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewCell.identifierCell, for: indexPath) as! HomeViewCell
    cell.populateView(item: (listItensOffiline[indexPath.row]))
    return cell
  }
  

  
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    
    let header = collectionView.dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: HomeHeaderViewCell.identifierCell,
      for: indexPath) as! HomeHeaderViewCell
    
    header.initView(user: viewModel!.currentUser)
    
    return header
    
  }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: view.frame.size.width, height: 150)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
      
    return CGSize(width: view.frame.size.width, height: 140)
  }
}
