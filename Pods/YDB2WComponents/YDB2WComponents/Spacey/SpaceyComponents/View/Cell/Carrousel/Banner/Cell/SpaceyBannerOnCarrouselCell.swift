//
//  SpaceyBannerOnCarrouselCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 12/05/21.
//

import UIKit

import YDB2WModels
import YDExtensions

class SpaceyBannerOnCarrouselCell: UICollectionViewCell {
  // MARK: Properties
  lazy var widthConstraint: NSLayoutConstraint = {
    widthAnchor.constraint(equalToConstant: 0)
  }()

  // MARK: Components
  let container = UIView()
  let imageView = UIImageView()

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureImageView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    clipsToBounds = false
    layer.masksToBounds = false
    contentView.clipsToBounds = false
    contentView.layer.masksToBounds = false

    container.layer.shadowPath = UIBezierPath(
      roundedRect: container.bounds,
      cornerRadius: 6
    ).cgPath
  }

  // MARK: Actions
  func configure(with banner: YDSpaceyComponentBanner) {
    imageView.setImage(banner.bannerImage)
  }
}

// MARK: Layouts
extension SpaceyBannerOnCarrouselCell {
  func configureImageView() {
    contentView.addSubview(container)
    container.backgroundColor = .white
    container.layer.cornerRadius = 6
    container.layer.applyShadow()

    container.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      container.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: 1
      ),
      container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      container.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor,
        constant: -1
      )
    ])

    //
    container.addSubview(imageView)
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = .white
    imageView.layer.cornerRadius = 6

    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: container.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
    ])
  }
}
