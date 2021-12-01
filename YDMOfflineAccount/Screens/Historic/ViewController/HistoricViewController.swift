//
//  HistoricViewController.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 02/02/21.
//

import UIKit
import Hero

import YDB2WAssets
import YDExtensions
import YDB2WIntegration
import YDB2WColors

class HistoricViewController: UIViewController {
  // MARK: Properties
  var viewModel: HistoricViewModelDelegate?
  var navBarShadowOff = true

  // MARK: Components
  let errorView = YDErrorView()

  // MARK: IBOutlets
  @IBOutlet weak var exportButton: UIButton! {
    didSet {
      exportButton.layer.cornerRadius = 6
      exportButton.layer.borderWidth = 1
      exportButton.layer.borderColor = YDColors.branding.cgColor
    }
  }

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

  @IBOutlet weak var separatorTopConstraint: NSLayoutConstraint!

  @IBOutlet weak var scrollView: UIScrollView! {
    didSet {
      scrollView.delegate = self
    }
  }

  @IBOutlet weak var stackView: UIStackView!

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureLayout()
    setBinds()
    viewModel?.getHistoricList()
  }

  // MARK: IBActions
  @IBAction func onExportAction(_ sender: Any) {
    if let image = snapshot() {
      let activityViewController = UIActivityViewController(
        activityItems: [image],
        applicationActivities: nil
      )

      viewModel?.trackExportMetric()
      present(activityViewController, animated: true, completion: nil)
    }
  }
}

// MARK: Actions
extension HistoricViewController {
  @objc func onBackAction(_ sender: UIButton) {
    viewModel?.onBack()
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

  func snapshot() -> UIImage? {
    guard let navBar = navigationController else { return nil }

    let holeScreenSize = CGSize(
      width: navBar.view.frame.size.width,
      height: (view.frame.size.height - scrollView.frame.height) + scrollView.contentSize.height + 150
    )

    let savedRootParentViewFrame = navigationController?.parent?.view.frame
    let savedNavBarFrame = navBar.view.frame
    let savedViewFrame = view.frame
    let savedScrollFrame = scrollView.frame
    let savedContentOffset = scrollView.contentOffset

    defer {
      UIGraphicsEndImageContext()

      navigationController?.parent?.view.frame = savedRootParentViewFrame ?? .zero
      navigationController?.parent?.view.subviews[1].frame = savedNavBarFrame
      navigationController?.view.frame = savedNavBarFrame
      view.frame = savedViewFrame
      scrollView.contentOffset = savedContentOffset
      scrollView.frame = savedScrollFrame
      createBackButton()
      exportButton.isHidden = false
      navBarShadowOff = true
      separatorTopConstraint.constant += 70
      view.layoutIfNeeded()
    }

    scrollView.contentOffset = .zero // CGPoint(x: 0, y: -20)
    navBarShadowOff = false
    separatorView.layer.opacity = 1
    shadowContainerView.layer.shadowOpacity = 0

    view.frame = CGRect(
      x: 0,
      y: 0,
      width: view.frame.size.width,
      height: holeScreenSize.height
    )

    navigationController?.parent?.view.frame = CGRect(
      x: 0,
      y: 0,
      width: view.frame.size.width,
      height: holeScreenSize.height
    )

    navigationController?.parent?.view.subviews[1].frame = CGRect(
      x: 0,
      y: 0,
      width: view.frame.size.width,
      height: holeScreenSize.height
    )

    navigationController?.view.frame = CGRect(
      x: 0,
      y: 0,
      width: view.frame.size.width,
      height: holeScreenSize.height
    )

    separatorTopConstraint.constant -= 70
    view.layoutIfNeeded()

    scrollView.frame = CGRect(
      x: 0,
      y: 0,
      width: scrollView.contentSize.width,
      height: scrollView.contentSize.height
    )
    scrollView.showsVerticalScrollIndicator = false

    navigationItem.setLeftBarButton(UIBarButtonItem(), animated: false)
    exportButton.isHidden = true

    let scale = UIScreen.main.scale
    UIGraphicsBeginImageContextWithOptions(holeScreenSize, false, scale)

    guard let context = UIGraphicsGetCurrentContext() else { return nil }

    navigationController?.view.layer.render(in: context)

    let image = UIGraphicsGetImageFromCurrentImageContext()
    return image
  }
}
