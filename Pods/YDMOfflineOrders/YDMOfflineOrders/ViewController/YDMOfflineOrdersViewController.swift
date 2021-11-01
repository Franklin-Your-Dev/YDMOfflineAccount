//
//  YDMOfflineOrdersViewController.swift
//  YDMOfflineOrders
//
//  Created by Douglas Hennrich on 21/02/21.
//

import UIKit
import YDB2WColors

public class YDMOfflineOrdersViewController: UIViewController {
  // MARK: Enum
  enum FeedbackStateViewType {
    case empty
    case error
  }

  // MARK: Properties
  var viewModel: YDMOfflineOrdersViewModelDelegate?
  var alreadyBindNavigation = false
  var navBarShadowOff = false
  var loadingShimmer = true
  var numberOfShimmers: Int?
  let cellSize: CGFloat = 175
  var canLoadMore = false
  var orderNoteButtonEnabled = false

  var feedbackMessageEmpty = """
  Ops! Você ainda não possui um histórico de compras realizadas em nossas lojas físicas.

  Pro seu histórico aparecer aqui, lembre sempre de informar seu CPF na hora do pagamento em uma de nossas lojas :)
  """
  var feedbackMessageError = "Ops! Falha ao carregar."
  var feedbackStateType: FeedbackStateViewType = .empty {
    didSet {
      // Icon
      feedbackStateIcon.isHidden = feedbackStateType == .error

      // Message
      feedbackMessage.text = feedbackStateType == .empty ? feedbackMessageEmpty : feedbackMessageError

      // Button
      let attributedString = NSAttributedString(
        string: feedbackStateType == .empty ? "ver loja mais próxima" : "atualizar",
        attributes: [
          NSAttributedString.Key.foregroundColor: YDColors.branding,
          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
        ]
      )
      feedbackStateButton.setAttributedTitle(attributedString, for: .normal)

      feedbackStateButtonWidthConstraint?.constant = feedbackStateType == .empty ? 175 : 86
      feedbackStateView.setNeedsLayout()
    }
  }

  // Components
  var collectionView: UICollectionView!
  var shadowView = UIView()
  var feedbackStateView = UIView()
  var feedbackStateIcon = UIImageView()
  var feedbackMessage = UILabel()
  var feedbackStateButton = UIButton()
  var feedbackStateButtonWidthConstraint: NSLayoutConstraint?
  var loadMoreShimmer: OrdersLoadingCollectionFooterReusableView?

  // MARK: Life cycle
  public override func viewDidLoad() {
    super.viewDidLoad()

    setUpLayout()
    setUpBinds()
    viewModel?.login()
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if !alreadyBindNavigation {
      alreadyBindNavigation = true
      viewModel?.setNavigationController(navigationController)
    }
  }
}

// MARK: Actions
extension YDMOfflineOrdersViewController {
  func toggleNavShadow(_ show: Bool) {
    DispatchQueue.main.async {
      if show {
        self.shadowView.backgroundColor = .white
        UIView.animate(withDuration: 0.5) { [weak self] in
          guard let self = self else { return }
          self.shadowView.layer.applyShadow(blur: 8, spread: 3)
        }
      } else {
        UIView.animate(withDuration: 0.5) { [weak self] in
          guard let self = self else { return }
          self.shadowView.layer.shadowOpacity = 0
          self.shadowView.backgroundColor = .clear
        }
      }
    }
  }

  func showFeedbackStateView(ofType type: FeedbackStateViewType) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      self.toggleNavShadow(false)
      Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
        self.navBarShadowOff = true
      }
      self.collectionView.isHidden = true
      self.feedbackStateView.isHidden = false
      self.feedbackStateType = type
      self.feedbackStateButton.isHidden = false
    }
  }

  @objc func onFeedbackButtonAction() {
    if feedbackStateType == .empty {
      viewModel?.onFeedbackButton()
    } else {
      viewModel?.login()
    }
  }

  func loadMoreFunc() {
    if viewModel?.noMoreOrderToLoad == false {
      if canLoadMore {
        canLoadMore = false
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
          guard let self = self else { return }
          self.viewModel?.getMoreOrders()
        }
      }

    } else {
      if loadMoreShimmer?.componentHidden == false {
        loadMoreShimmer?.componentHidden = true
        // hide shimmer
        loadMoreShimmer?.stopShimmerAndHide()
        collectionView.collectionViewLayout.invalidateLayout()
      }
    }
  }
}
