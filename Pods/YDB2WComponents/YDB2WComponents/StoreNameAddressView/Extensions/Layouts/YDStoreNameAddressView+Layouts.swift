//
//  YDStoreNameAddressView+Layouts.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 07/04/21.
//
import UIKit
import YDExtensions
import YDB2WColors

// MARK: Layout
extension YDStoreNameAddressView {
  func setUpLayouts() {
    createContainerView()
    createStoreNameLabel()
    createStoreAddressLabel()

    if hasButton {
      createButton()
    }

    // Shimmer
    createShimmerContainer()
    createShimmerStoreNameLabel()
    createShimmerStoreAddressLabel()

    shimmers = [
      shimmerNameLabel,
      shimmerAddressLabel
    ]

    if hasButton {
      createShimmerButton()
    }
  }

  private func createContainerView() {
    addSubview(container)

    container.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      container.topAnchor.constraint(equalTo: topAnchor),
      container.leadingAnchor.constraint(equalTo: leadingAnchor),
      container.trailingAnchor.constraint(equalTo: trailingAnchor),
      container.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  private func createStoreNameLabel() {
    storeNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
    storeNameLabel.textAlignment = .left
    storeNameLabel.textColor = YDColors.black
    storeNameLabel.numberOfLines = 1
    storeNameLabel.text = .lorem(ofLength: 50)
    container.addSubview(storeNameLabel)

    storeNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      storeNameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
      storeNameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
      storeNameLabel.trailingAnchor.constraint(
        equalTo: container.trailingAnchor,
        constant: hasButton ? -73 : -16
      ),
      storeNameLabel.heightAnchor.constraint(equalToConstant: 18)
    ])
  }

  private func createStoreAddressLabel() {
    storeAddressLabel.font = .systemFont(ofSize: 14)
    storeAddressLabel.textAlignment = .left
    storeAddressLabel.textColor = YDColors.Gray.light
    storeAddressLabel.numberOfLines = 2
    storeAddressLabel.text = .lorem(ofLength: 50)
    container.addSubview(storeAddressLabel)

    storeAddressLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      storeAddressLabel.topAnchor.constraint(
        equalTo: storeNameLabel.bottomAnchor,
        constant: 3
      ),
      storeAddressLabel.leadingAnchor
        .constraint(equalTo: storeNameLabel.leadingAnchor),
      storeAddressLabel.trailingAnchor
        .constraint(
          equalTo: container.trailingAnchor,
          constant: hasButton ? -73 : -8
        ),
      storeAddressLabel.heightAnchor
        .constraint(greaterThanOrEqualToConstant: 18),
      storeAddressLabel.bottomAnchor
        .constraint(equalTo: container.bottomAnchor, constant: -16)
    ])
    storeAddressLabel.setContentCompressionResistancePriority(
      .defaultHigh,
      for: .vertical
    )
  }

  private func createButton() {
    let title = "trocar"
    let attributedString = NSMutableAttributedString(string: title)

    attributedString.addAttributes(
      [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: YDColors.branding
      ],
      range: NSRange(location: 0, length: title.count)
    )

    actionButton.setAttributedTitle(attributedString, for: .normal)
    actionButton.titleEdgeInsets = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    container.addSubview(actionButton)

    actionButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      actionButton.widthAnchor.constraint(equalToConstant: 60),
      actionButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
      actionButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
      actionButton.trailingAnchor.constraint(equalTo: container.trailingAnchor)
    ])

    actionButton.addTarget(self, action: #selector(onButtonAction), for: .touchUpInside)
  }
}

// MARK: Shimmer
extension YDStoreNameAddressView {
  func createShimmerContainer() {
    shimmerContainer.isHidden = true
    addSubview(shimmerContainer)

    shimmerContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerContainer.topAnchor
        .constraint(equalTo: container.topAnchor),
      shimmerContainer.leadingAnchor
        .constraint(equalTo: container.leadingAnchor),
      shimmerContainer.trailingAnchor
        .constraint(equalTo: container.trailingAnchor),
      shimmerContainer.bottomAnchor
        .constraint(equalTo: container.bottomAnchor)
    ])
  }

  func createShimmerStoreNameLabel() {
    shimmerContainer.addSubview(shimmerNameLabel)
    shimmerNameLabel.backgroundColor = .white
    shimmerNameLabel.layer.cornerRadius = 4

    shimmerNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerNameLabel.topAnchor.constraint(
        equalTo: shimmerContainer.topAnchor,
        constant: 16
      ),
      shimmerNameLabel.leadingAnchor.constraint(
        equalTo: shimmerContainer.leadingAnchor,
        constant: 16
      ),
      shimmerNameLabel.trailingAnchor.constraint(
        equalTo: shimmerContainer.trailingAnchor,
        constant: hasButton ? -73 : -16
      ),
      shimmerNameLabel.heightAnchor.constraint(equalToConstant: 18)
    ])
  }

  func createShimmerStoreAddressLabel() {
    shimmerAddressLabel.backgroundColor = .white
    shimmerAddressLabel.layer.cornerRadius = 4
    shimmerContainer.addSubview(shimmerAddressLabel)

    shimmerAddressLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerAddressLabel.topAnchor.constraint(
        equalTo: shimmerNameLabel.bottomAnchor,
        constant: 3
      ),
      shimmerAddressLabel.bottomAnchor
        .constraint(equalTo: shimmerContainer.bottomAnchor, constant: -16),
      shimmerAddressLabel.leadingAnchor
        .constraint(equalTo: shimmerNameLabel.leadingAnchor),
      shimmerAddressLabel.trailingAnchor
        .constraint(
          equalTo: container.trailingAnchor,
          constant: hasButton ? -73 : -8
        )
    ])
  }

  func createShimmerButton() {
    shimmerActionButton.text = "trocar"
    shimmerActionButton.textColor = YDColors.branding
    shimmerActionButton.font = .systemFont(ofSize: 14)
    shimmerActionButton.layer.opacity = 0.3
    shimmerContainer.addSubview(shimmerActionButton)

    shimmerActionButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerActionButton.widthAnchor.constraint(equalToConstant: 50),
      shimmerActionButton.topAnchor
        .constraint(equalTo: shimmerContainer.topAnchor, constant: 35),
      shimmerActionButton.bottomAnchor.constraint(
        equalTo: shimmerContainer.bottomAnchor,
        constant: -17
      ),
      shimmerActionButton.trailingAnchor.constraint(
        equalTo: shimmerContainer.trailingAnchor
      )
    ])
  }
}
