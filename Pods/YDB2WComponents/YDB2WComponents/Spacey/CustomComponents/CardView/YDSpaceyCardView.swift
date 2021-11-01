//
//  YDSpaceyCardView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 10/06/21.
//

import UIKit
import YDExtensions
import YDB2WModels
import YDUtilities
import YDB2WAssets
import YDB2WColors

public class YDSpaceyCardView: UIView {
  // MARK: Properties
  public var callback: ((_ card: YDSpaceyComponentLiveNPSCard?, _ cardTag: Int) -> Void)?
  public var stateView: YDUIStateEnum = .normal {
    didSet {
      changeUIState(with: stateView)
    }
  }
  public var card: YDSpaceyComponentLiveNPSCard?
  var currentItems: [YDSpaceyComponentLiveNPSCardQuestion] = []
  var components: [UIView] = []
  var emptyComponents: [UIView] = []

  // MARK: Components
  let titleLabel = UILabel()
  public let skipButton = UIButton()
  let vStackView = UIStackView()
  let stackView = UIStackView()

  let emptyIconImageView = UIImageView()
  let emptyTitleLabel = UILabel()
  let emptyBodyLabel = UILabel()

  // MARK: Init
  public init() {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .white
    layer.cornerRadius = 8
    layer.applyShadow(alpha: 0.08, y: 6, blur: 20, spread: -1)
    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
  public func configure(with card: YDSpaceyComponentLiveNPSCard) {
    self.card = card
    self.currentItems = card.children
    self.stateView = .normal
    titleLabel.text = card.title

    for (index, item) in currentItems.enumerated() {
      let cardView = YDSpaceyInnerCardView(with: item)
      cardView.tag = index
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onAction))
      cardView.addGestureRecognizer(tapGesture)
      stackView.addArrangedSubview(cardView)
    }
  }

  public func cleanUpCard() {
    callback = nil
    card = nil
    titleLabel.text = nil
    stackView.subviews.forEach { $0.removeFromSuperview() }
    stateView = .normal
  }

  @objc func onAction(_ sender: UIGestureRecognizer) {
    guard let index = sender.view?.tag,
      let selectedItem = currentItems.at(index) else { return }
    card?.storedValue = selectedItem.title
    callback?(card, skipButton.tag)
  }
}

// MARK: UI
extension YDSpaceyCardView {
  func configureUI() {
    configureSkipButton()
    configureTitleLabel()
    configureStackView()

    configureEmptyIcon()
    configureEmptyTitleLabel()
    configureEmptyBodyLabel()
  }

  func configureTitleLabel() {
    addSubview(titleLabel)
    components.append(titleLabel)

    titleLabel.textColor = YDColors.black
    titleLabel.textAlignment = .left
    titleLabel.font = .boldSystemFont(ofSize: 14)
    titleLabel.numberOfLines = 2

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.centerYAnchor.constraint(equalTo: skipButton.centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleLabel.trailingAnchor
        .constraint(equalTo: skipButton.leadingAnchor, constant: -10),
      titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22)
    ])
    titleLabel.setContentCompressionResistancePriority(
      .defaultHigh,
      for: .vertical
    )
  }

  func configureSkipButton() {
    addSubview(skipButton)

    let attributedString = NSAttributedString(
      string: "PULAR",
      attributes: [
        NSAttributedString.Key.foregroundColor: YDColors.Gray.light,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
      ]
    )

    skipButton.setAttributedTitle(attributedString, for: .normal)
    skipButton.backgroundColor = .clear

    skipButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      skipButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      skipButton.widthAnchor.constraint(equalToConstant: 70),
      skipButton.heightAnchor.constraint(equalToConstant: 40),
      skipButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6)
    ])
  }

  func configureStackView() {
    addSubview(vStackView)
    components.append(vStackView)

    vStackView.alignment = .center
    vStackView.axis = .vertical

    vStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      vStackView.topAnchor.constraint(equalTo: skipButton.bottomAnchor, constant: 9),
      vStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      vStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      vStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
    ])

    vStackView.addArrangedSubview(stackView)
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.spacing = 16
  }

  func configureEmptyIcon() {
    addSubview(emptyIconImageView)
    emptyComponents.append(emptyIconImageView)

    emptyIconImageView.tintColor = YDColors.Gray.night
    emptyIconImageView.image = YDAssets.Icons.thumbUpWired

    emptyIconImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      emptyIconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 21),
      emptyIconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      emptyIconImageView.widthAnchor.constraint(equalToConstant: 90),
      emptyIconImageView.heightAnchor.constraint(equalToConstant: 90)
    ])
  }

  func configureEmptyTitleLabel() {
    addSubview(emptyTitleLabel)
    emptyComponents.append(emptyTitleLabel)

    emptyTitleLabel.textColor = YDColors.black
    emptyTitleLabel.font = .boldSystemFont(ofSize: 16)
    emptyTitleLabel.textAlignment = .center
    emptyTitleLabel.text = "Obrigada pela sua contribuição!"

    emptyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      emptyTitleLabel.topAnchor.constraint(equalTo: emptyIconImageView.bottomAnchor, constant: 10),
      emptyTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
    ])
  }

  func configureEmptyBodyLabel() {
    addSubview(emptyBodyLabel)
    emptyComponents.append(emptyBodyLabel)

    emptyBodyLabel.textColor = YDColors.Gray.light
    emptyBodyLabel.font = .systemFont(ofSize: 14)
    emptyBodyLabel.textAlignment = .center
    emptyBodyLabel.text = "Suas respostas foram enviadas ao nosso time"

    emptyBodyLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      emptyBodyLabel.topAnchor.constraint(equalTo: emptyTitleLabel.bottomAnchor, constant: 2),
      emptyBodyLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
    ])
  }
}

// MARK: UIState Delegate
extension YDSpaceyCardView: YDUIStateDelegate {
  public func changeUIState(with type: YDUIStateEnum) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      self.components.forEach { $0.isHidden = type == .empty }
      self.emptyComponents.forEach { $0.isHidden = type == .normal }

      let attributedString = NSAttributedString(
        string: type == .normal ? "PULAR" : "FECHAR",
        attributes: [
          NSAttributedString.Key.foregroundColor: YDColors.Gray.light,
          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]
      )
      self.skipButton.setAttributedTitle(attributedString, for: .normal)
    }
  }
}
