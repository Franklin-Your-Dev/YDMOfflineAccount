//
//  UserDataViewController.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 14/01/21.
//

import UIKit

import YDB2WAssets
import YDExtensions

class UserDataViewController: UIViewController {
  // MARK: Properties
  var viewModel: UserDataViewModelDelegate?
  var navBarShadowOff = false

  // MARK: Components
  let errorView = YDErrorView()

  // MARK: IBOutlets
  @IBOutlet weak var lastUpdateLabelTitle: UILabel!

  @IBOutlet weak var lastUpdateLabel: UILabel!

  @IBOutlet weak var historicButton: UIButton!

  @IBOutlet weak var tableView: UITableView!  {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
      tableView.tableFooterView = UIView()

      let bundle = Bundle.init(for: UserDataViewController.self)

      // Users Info
      tableView.register(
        UserDataInfoTableViewCell.loadNib(bundle),
        forCellReuseIdentifier: UserDataInfoTableViewCell.identifier
      )

      // Separator
      tableView.register(
        UserDataSeparatorTableViewCell.loadNib(bundle),
        forCellReuseIdentifier: UserDataSeparatorTableViewCell.identifier
      )

      // Marketing Switcher
      tableView.register(
        UserDataMarketingTableViewCell.loadNib(bundle),
        forCellReuseIdentifier: UserDataMarketingTableViewCell.identifier
      )

      // Terms Switcher & Save Button
      tableView.register(
        UserDataTermsAndButtonTableViewCell.loadNib(bundle),
        forCellReuseIdentifier: UserDataTermsAndButtonTableViewCell.identifier
      )
    }
  }

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  @IBOutlet weak var shadowContainerView: UIView! {
    didSet {
      shadowContainerView.backgroundColor = .white
      shadowContainerView.layer.zPosition = 5
    }
  }

  @IBOutlet weak var separatorView: UIView! {
    didSet {
      separatorView.layer.zPosition = 6
    }
  }

  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureLayout()
    setBinds()

    viewModel?.getUsersInfo()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(onTermsNotification),
      name: NSNotification.Name("openTerms"),
      object: nil
    )
  }

  // MARK: IBActions
  @IBAction func onHistoricAction(_ sender: Any) {
    viewModel?.openHistoric()
  }

  // MARK: Actions
  @objc func onBackAction(_ sender: UIButton) {
    viewModel?.onBack()
  }

  @objc func onTermsNotification() {
    viewModel?.openTerms()
  }

  func toggleNavShadow(_ show: Bool) {
    DispatchQueue.main.async { [weak self] in
      if show {
        UIView.animate(withDuration: 0.5) { [weak self] in
          self?.shadowContainerView.layer.applyShadow()
          self?.separatorView.isHidden = true
        }
      } else {
        UIView.animate(withDuration: 0.5) { [weak self] in
          self?.shadowContainerView.layer.shadowOpacity = 0
          self?.separatorView.isHidden = false
        }
      }
    }
  }
}
