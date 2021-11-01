//
//  StoreAndProductView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 25/03/21.
//

import UIKit

import YDExtensions
import YDB2WModels
import YDUtilities
import YDB2WColors

// MARK: Delegate
public protocol YDStoreAndProductDelegate: AnyObject {
  func onChangeStoreAction()
  func didMove(direction: YDStoreAndProductView.ScrollDirection)
}

// MARK: View
public class YDStoreAndProductView: UIView {
  // MARK: Enum
  public enum ScrollDirection {
    case up
    case down
  }

  // MARK: Properties
  public var stateView: YDUIStateEnum = .normal {
    didSet {
      changeUIState(with: stateView)
    }
  }
  public var product: YDProduct? {
    didSet {
      updateLayoutWithProduct()
    }
  }
  public var store: YDStore? {
    didSet {
      updateLayoutWithStore()
    }
  }
  public weak var delegate: YDStoreAndProductDelegate?
  var lastContentOffset: CGFloat = 0
  public var errorStateActionCallback: ((UIButton) -> Void)? {
    didSet {
      errorViewActionButton.callback = errorStateActionCallback
    }
  }

  // MARK: Components
  let storeNameAndAddressView = YDStoreNameAddressView(withButton: true)
  let separatorView = UIView()
  let productCardView = YDProductCardView()
  let segmentedControl = YDSegmentedControl()
  let textView = UITextView()
  let tableView = UITableView()
  let shimmerTextView = UIView()
  let emptyView = UIView()
  let errorView = UIView()
  let errorViewActionButton = YDWireButton(withTitle: "atualizar")

  // MARK: Init
  public init() {
    super.init(frame: .zero)

    backgroundColor = YDColors.white
    layer.applyShadow(x: 0, y: 0, blur: 20)
    layer.cornerRadius = 16

    setUpLayouts()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
  func updateLayoutWithProduct() {
    guard let product = self.product else { return }
    productCardView.product = product

    let description = product.getHtmlDescription()
    let technicalInformation = product.getTechnicalInformation()

    if description == nil {
      segmentedControl.setEnabled(false, forSegmentAt: 0)
      textView.text = ""
    } else {
      segmentedControl.setEnabled(true, forSegmentAt: 0)
      segmentedControl.selectedSegmentIndex = 0
      changeSegmentControl(0)
      textView.attributedText = description
    }

    if technicalInformation.isEmpty {
      segmentedControl.setEnabled(false, forSegmentAt: 1)
    } else {
      segmentedControl.setEnabled(true, forSegmentAt: 1)
      tableView.reloadData()
    }
  }

  private func updateLayoutWithStore() {
    guard let store = self.store else { return }

    storeNameAndAddressView.changeValues(
      storeName: store.name,
      storeAddress: store.formatAddress
    )
  }
}
