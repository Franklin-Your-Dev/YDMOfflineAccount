//
//  SpaceyBannerShimmerTableViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 18/04/21.
//

import UIKit

import YDExtensions

class SpaceyBannerShimmerTableViewCell: UITableViewCell {
  // Components
  let containerView = UIView()

  // Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func config() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.containerView.startShimmer()
    }
  }
}

// MARK: Layout
extension SpaceyBannerShimmerTableViewCell {
  func configureLayout() {
    selectionStyle = .none

    contentView.layer.applyShadow()
    contentView.addSubview(containerView)
    containerView.backgroundColor = .white
    containerView.layer.cornerRadius = 6
    containerView.layer.masksToBounds = true
    containerView.layer.applyShadow()

    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: 12
      ),
      containerView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: 16
      ),
      containerView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -16
      ),
      containerView.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor,
        constant: -12
      )
    ])
  }
}
