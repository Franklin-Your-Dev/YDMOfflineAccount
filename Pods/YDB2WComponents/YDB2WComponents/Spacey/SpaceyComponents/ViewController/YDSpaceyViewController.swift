//
//  SpaceyViewController.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 14/04/21.
//

import UIKit

import YDB2WModels

public class YDSpaceyViewController: UIViewController {
  // MARK: Properties
  public var viewModel: YDSpaceyViewModelDelegate?
  public weak var delegate: YDSpaceyControllerDelegate?
  public var largerHeader = false
  public var collectionContentHeight: CGFloat = 0 {
    didSet {
      delegate?.onChange(
        size: CGSize(
          width: collectionView.contentSize.width,
          height: collectionContentHeight
        )
      )
    }
  }
  public var hasShimmer = true
  public var isProductCarouselCouponEnabled = true

  var numberOfShimmers = 0
  var bannerCellSize: CGFloat = 180
  var textViewIndex = 0

  // MARK: Components
  public var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()
  )
  public lazy var collectionHeightConstraint: NSLayoutConstraint = {
    let height = collectionView.heightAnchor.constraint(equalToConstant: 0)
    height.isActive = true
    return height
  }()

  let shimmerTableView = UITableView()

  // MARK: Life cycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    configureLayout()
    configureBinds()
    delegate?.registerCustomCells(collectionView)
  }

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionContentHeight = collectionView.collectionViewLayout
      .collectionViewContentSize.height
  }
}

// MARK: Actions
public extension YDSpaceyViewController {}

// MARK: Public Actions
public extension YDSpaceyViewController {
  func getSpacey(withId id: String, customApi: String? = nil) {
    viewModel?.getSpacey(withId: id, customApi: customApi)
  }

  func getList() -> [YDSpaceyCommonStruct] {
    return viewModel?.componentsList.value ?? []
  }

  func set(list: [YDSpaceyCommonStruct]) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      
      self.viewModel?.componentsList.value = list
      self.collectionView.reloadData()
      self.collectionView.collectionViewLayout.invalidateLayout()
      self.collectionView.isHidden = false
      self.shimmerTableView.isHidden = true
      self.view.setNeedsLayout()
    }
  }
  
  func refreshList() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.collectionView.reloadData()
      self.collectionView.isHidden = false
      self.shimmerTableView.isHidden = true
    }
  }
}
