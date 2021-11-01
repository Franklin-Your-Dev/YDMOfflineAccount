//
//  SpaceyBannerCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 16/04/21.
//

import UIKit
import YDB2WModels
import YDExtensions
import YDB2WColors
import Kingfisher

class SpaceyBannerCollectionViewCell: UICollectionViewCell {
  // Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()
  let imageContainer = UIView()
  let imageView = UIImageView()
  lazy var imageViewHeightConstraint: NSLayoutConstraint = {
    return imageView.heightAnchor.constraint(equalToConstant: 80)
  }()

  // Properties
  var component: YDSpaceyComponentBanner?
  let padding: CGFloat = 32
  var needsToUpdateCallback: (() -> Void)?

  // Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.translatesAutoresizingMaskIntoConstraints = false

    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
    imageView.frame = .zero
    imageView.stopShimmer()
    component = nil
    needsToUpdateCallback = nil
  }

  override func systemLayoutSizeFitting(
    _ targetSize: CGSize,
    withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
    verticalFittingPriority: UILayoutPriority
  ) -> CGSize {
    width.constant = bounds.size.width
    return contentView.systemLayoutSizeFitting(
      CGSize(width: targetSize.width, height: 1)
    )
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    imageContainer.layer.shadowPath = UIBezierPath(
      roundedRect: imageContainer.bounds,
      cornerRadius: 6
    ).cgPath
  }

  // MARK: Actions
  func config(with component: YDSpaceyComponentBanner) {
    self.component = component

    if let height = component.currentImageHeight {
      imageView.frame.size = CGSize(width: width.constant - padding, height: height)
      imageView.setImage(component.bannerImage)
      updateLayout()
      return
    } else {
      imageViewHeightConstraint.constant = 80
    }
    imageView.startShimmer()
    imageView.setImage(component.bannerImage) { [weak self] success in
      guard let self = self else { return }
      self.onImageCallback(success, fromGrid: true)
    }
  }

  func onImageCallback(_ success: RetrieveImageResult?, fromGrid: Bool = false) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.imageView.stopShimmer()

      if success != nil {
        guard let image = self.imageView.image else { return }

        let width = self.width.constant
        let ratio = (width - self.padding) / CGFloat(image.size.width)

        let onScreenBannerHeight = image.size.height * ratio

        self.imageView.frame.size = CGSize(
          width: width - self.padding,
          height: onScreenBannerHeight
        )

        self.component?.currentImageHeight = onScreenBannerHeight
      } else {
        self.imageContainer.isHidden = true
        self.imageView.frame.size = .zero
      }

      self.updateLayout()
    }
  }

  func updateLayout() {
    imageViewHeightConstraint.constant = imageView.frame.size.height
    layoutIfNeeded()
    needsToUpdateCallback?()
  }
}

// MARK: Layout
extension SpaceyBannerCollectionViewCell {
  func configureLayout() {
    configureImageContainer()
    configureImageView()
  }

  func configureImageContainer() {
    contentView.addSubview(imageContainer)
    imageContainer.backgroundColor = YDColors.Gray.opaque
    imageContainer.layer.cornerRadius = 6
    imageContainer.layer.applyShadow()

    imageContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
      imageContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
      imageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      imageContainer.trailingAnchor
        .constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
  }

  func configureImageView() {
    imageContainer.addSubview(imageView)
    imageView.backgroundColor = YDColors.Gray.opaque
    imageView.layer.cornerRadius = 6
    imageView.contentMode = .scaleAspectFill

    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageViewHeightConstraint.isActive = true

    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
      imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
      imageView.trailingAnchor
        .constraint(equalTo: imageContainer.trailingAnchor)
    ])
  }
}
