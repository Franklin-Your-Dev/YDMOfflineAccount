//
//  YDNextLiveView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 05/07/21.
//

import UIKit
import YDB2WModels
import YDB2WAssets
import YDExtensions
import YDUtilities
import YDB2WColors

public class YDNextLiveView: UIView {
  // MARK: Properties
  var views: [UIView] = []
  var hasButton = true

  public var callback: (() -> Void)?
  public var stateView: YDUIStateEnum = .normal {
    didSet {
      changeUIState(with: stateView)
    }
  }

  // MARK: Components
  let photoBackgroundView = UIView()
  let photoPlaceImage = UIImageView()
  let photoImageView = UIImageView()
  
  let dateLabel = UILabel()
  
  let nameLabel = UILabel()
  let descriptionLabel = UILabel()
  let scheduleButton = UIButton()

  // MARK: Init
  public init() {
    super.init(frame: .zero)
    configureLayout()
  }

  public init(hasButton: Bool) {
    super.init(frame: .zero)
    self.hasButton = hasButton
    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
  public func cleanUp() {
    photoImageView.image = nil
    photoPlaceImage.isHidden = false
    
    dateLabel.text = nil
    nameLabel.text = nil
    descriptionLabel.text = nil
    callback = nil
    stateView = .normal
  }

  public func config(with live: YDSpaceyComponentNextLive?) {
    guard let live = live else { return }
    
    photoPlaceImage.isHidden = false
    
    photoImageView.setImage(
      live.photo
    ) { [weak self] success in
      guard let self = self else { return }
      guard success != nil else { return }
      self.photoPlaceImage.isHidden = true
    }
    
    dateLabel.text = live.formatedDate
    nameLabel.text = live.name
    descriptionLabel.text = live.description
    setStyle(isAvailable: live.isAvailable, isLive: live.isLive)
  }

  public func setStyle(isAvailable: Bool, isLive: Bool) {
    dateLabel.textColor = isAvailable ? YDColors.Gray.light: YDColors.Gray.night
    dateLabel.textColor = isLive ?
      YDColors.Red.night :
      YDColors.Gray.light

    if !hasButton { return }

    scheduleButton.tintColor = isAvailable ? YDColors.branding : YDColors.Gray.light
    scheduleButton.setAttributedTitle(
      NSAttributedString(
        string: isAvailable ? "adicionar" :
          isLive ? "adicionar" : "adicionado",
        attributes: [
          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
          NSAttributedString.Key.foregroundColor: isAvailable ?
            YDColors.branding : YDColors.Gray.night
        ]
      ),
      for: .normal
    )
    scheduleButton.isEnabled = isAvailable
  }

  @objc func onButtonAction() {
    callback?()
  }
}

// MARK: UIState Delegate
extension YDNextLiveView: YDUIStateDelegate {
  public func changeUIState(with type: YDUIStateEnum) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      if type == .normal {
        self.views.forEach { $0.stopShimmer() }
      } else if type == .loading {
        self.views.forEach { $0.startShimmer() }
      }
    }
  }
}

// MARK: UI
extension YDNextLiveView {
  func configureLayout() {
    configureView()
    configurePhotoImageView()
    configureDateLabel()
    configureNameLabel()
    configureDescriptionLabel()
    
    if !hasButton { return }

    configureScheduleButton()
  }
  
  private func configureView() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = YDColors.white
    layer.applyShadow(alpha: 0.08, y: 6, blur: 20, spread: -1)
    layer.cornerRadius = 6
  }
  
  // Photo
  private func configurePhotoImageView() {
    // Container
    photoBackgroundView.layer.cornerRadius = 4
    photoBackgroundView.layer.masksToBounds = true
    photoBackgroundView.backgroundColor = YDColors.Gray.surface
    addSubview(photoBackgroundView)

    photoBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      photoBackgroundView.widthAnchor.constraint(equalToConstant: 126),
      photoBackgroundView.heightAnchor.constraint(equalToConstant: 126),
      photoBackgroundView.topAnchor.constraint(
        equalTo: topAnchor,
        constant: 14
      ),
      photoBackgroundView.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: 10
      ),
      photoBackgroundView.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -20
      )
    ])

    // Placeholder
    photoBackgroundView.addSubview(photoPlaceImage)
    photoPlaceImage.image = YDAssets.Icons.imagePlaceHolder
    photoPlaceImage.tintColor = YDColors.Gray.night
    photoPlaceImage.translatesAutoresizingMaskIntoConstraints = false
    photoPlaceImage.bindFrame(
      top: 16,
      bottom: -16,
      leading: 16,
      trailing: -16,
      toView: photoBackgroundView
    )
    
    // Image
    photoBackgroundView.addSubview(photoImageView)
    photoImageView.layer.cornerRadius = 4
    photoImageView.layer.masksToBounds = true
    photoImageView.contentMode = .scaleAspectFill

    photoImageView.translatesAutoresizingMaskIntoConstraints = false
    photoImageView.bindFrame(toView: photoBackgroundView)
  }

  // Date
  private func configureDateLabel() {
    dateLabel.textColor = YDColors.Gray.light
    dateLabel.font = .systemFont(ofSize: 12, weight: .bold)
    dateLabel.textAlignment = .left
    addSubview(dateLabel)

    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
      dateLabel.leadingAnchor
        .constraint(equalTo: photoBackgroundView.trailingAnchor, constant: 12),
      dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
      dateLabel.heightAnchor.constraint(equalToConstant: 14)
    ])
  }

  // Name
  private func configureNameLabel() {
    nameLabel.textColor = YDColors.black
    nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
    nameLabel.textAlignment = .left
    nameLabel.numberOfLines = 2
    addSubview(nameLabel)

    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
      nameLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
      nameLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
      nameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 19)
    ])
    nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
  }

  // Description
  private func configureDescriptionLabel() {
    descriptionLabel.textColor = YDColors.Gray.light
    descriptionLabel.font = .systemFont(ofSize: 12)
    descriptionLabel.textAlignment = .left
    descriptionLabel.numberOfLines = 2
    addSubview(descriptionLabel)

    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
      descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
    ])
  }

  // Schedule Button
  private func configureScheduleButton() {
    scheduleButton.tintColor = YDColors.branding
    let title = "adicionar"
    let attributeString = NSMutableAttributedString(string: title)

    attributeString.addAttributes(
      [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
        NSAttributedString.Key.foregroundColor: YDColors.branding
      ],
      range: NSRange(location: 0, length: title.utf8.count)
    )

    scheduleButton.setAttributedTitle(attributeString, for: .normal)
    scheduleButton.setImage(YDAssets.Icons.scheduleLive, for: .normal)
    scheduleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    scheduleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
    scheduleButton.contentHorizontalAlignment = .right
    addSubview(scheduleButton)

    scheduleButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      scheduleButton.heightAnchor.constraint(equalToConstant: 40),
      scheduleButton.widthAnchor.constraint(equalToConstant: 120),
      scheduleButton.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
      scheduleButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
    ])

    scheduleButton.addTarget(self, action: #selector(onButtonAction), for: .touchUpInside)
  }
}
