//
//  YDLoginDialogViewController.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 04/11/20.
//

import UIKit

import YDB2WAssets
import YDExtensions
import YDB2WColors

class YDLoginDialogViewController: UIViewController {
  // MARK: Properties
  var viewModel: YDLoginDialogViewModelDelegate?

  // MARK: IBOutlets
  @IBOutlet weak var contentView: UIView! {
    didSet {
      contentView.layer.cornerRadius = 6
      contentView.layer.applyShadow(alpha: 0.08, blur: 20, spread: -1)
    }
  }

  @IBOutlet weak var iconImageView: UIImageView! {
    didSet {
      iconImageView.tintColor = YDColors.branding
      iconImageView.image = YDAssets.Icons.userWired
    }
  }
  
  @IBOutlet weak var loginButton: UIButton! {
    didSet {
      loginButton.layer.borderWidth = 1
      loginButton.layer.borderColor = YDColors.branding.cgColor
      loginButton.layer.cornerRadius = 4
    }
  }

  @IBOutlet weak var exitButton: UIButton!

  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: IBActions
  @IBAction func onLogin(_ sender: UIButton) {
    viewModel?.onLogin()
  }

  @IBAction func onExit(_ sender: UIButton) {
    viewModel?.onExit()
  }
}
