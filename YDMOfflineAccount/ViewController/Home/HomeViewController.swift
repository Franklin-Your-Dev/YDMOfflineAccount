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
  // MARK: Properties
  var viewModel: HomeViewModelDelegate?
  var navBarShadowOff = true

  // MARK: IBOutlets
  @IBOutlet weak var scrollView: UIScrollView! {
    didSet {
      scrollView.delegate = self
    }
  }

  @IBOutlet weak var shadowView: UIView! {
    didSet {
      shadowView.backgroundColor = .white
      shadowView.layer.zPosition = 5
    }
  }

  @IBOutlet weak var stackView: UIStackView!

  @IBOutlet weak var userProfileView: YDUserProfileView!

  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "meu perfil modo loja"
    navigationController?.navigationBar.barTintColor = .white

    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
      top: view.safeAreaInsets.top + 20,
      leading: 0,
      bottom: view.safeAreaInsets.bottom + 40,
      trailing: 0
    )

    createBackButton()
    setBinds()
    buildCards()

    viewModel?.trackState()
    userProfileView.config(username: viewModel?.currentUser.fullName ?? "", userPhoto: nil)
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

  func buildCards() {
    stackView.setCustomSpacing(31, after: userProfileView)

    let cards: [[String: Any]] = [
//      [
//        "icon": Images.qrCode as Any,
//        "title": "vai se identificar no caixa das lojas físicas?",
//        "button": "acesse aqui!",
//        "id": 1
//      ],
      [
        "icon": YDAssets.Images.store as Any,
        "title": "suas compras nas lojas físicas",
        "id": 3
      ],
      [
        "icon": YDAssets.Images.clipboard as Any,
        "title": "seu histórico de dados informados nas lojas",
        "id": 2
      ]
    ]

    for curr in cards {
      let card = UIView()
      card.backgroundColor = .white
      card.layer.cornerRadius = 16
      card.layer.applyShadow(blur: 20)
      card.tag = curr["id"] as? Int ?? 0

      card.addGestureRecognizer(
        UITapGestureRecognizer(target: self,
                               action: #selector(onCardAction))
      )

      stackView.addArrangedSubview(card)

      card.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        card.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 24),
        card.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -24),
        card.heightAnchor.constraint(equalToConstant: 138)
      ])

      // Icon
      let imageView = UIImageView()
      imageView.image = curr["icon"] as? UIImage
      card.addSubview(imageView)

      let size: CGFloat = 100
      let iconLeading: CGFloat = 26

      imageView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        imageView.widthAnchor.constraint(equalToConstant: size),
        imageView.heightAnchor.constraint(equalToConstant: size),
        imageView.centerYAnchor.constraint(equalTo: card.centerYAnchor),
        imageView.leadingAnchor
          .constraint(equalTo: card.leadingAnchor, constant: iconLeading)
      ])

      // Title
      let titleLabel = UILabel()
      titleLabel.text = curr["title"] as? String
      titleLabel.textAlignment = .center
      titleLabel.textColor = YDColors.black
      titleLabel.font = .systemFont(ofSize: 16)
      titleLabel.numberOfLines = 0
      card.addSubview(titleLabel)

      titleLabel.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
        titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
        titleLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor)
      ])
    }
  }

  @objc func onCardAction(_ sender: UIGestureRecognizer) {
    guard let tag = sender.view?.tag else { return }

    //
    viewModel?.onCard(tag: tag)
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
