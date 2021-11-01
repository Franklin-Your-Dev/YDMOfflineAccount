//
//  SpaceyTitleCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 10/05/21.
//

import UIKit
import YDExtensions
import YDB2WColors

class SpaceyTitleCollectionViewCell: UICollectionViewCell {
  // MARK: Components
  let titleLabel = UILabel()
  lazy var trailingPadding: NSLayoutConstraint = {
    let padding = titleLabel.trailingAnchor.constraint(
      equalTo: contentView.trailingAnchor,
      constant: -16
    )

    return padding
  }()
  let livePulseView = UIView()

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.widthAnchor
          .constraint(equalToConstant: frame.size.width).isActive = true
    configureTitleLabel()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    NotificationCenter.default.removeObserver(self)
    self.livePulseView.stopPulsating()
  }

  // MARK: Configure
  func configure(withTitle title: String?, hasLivePulsing: Bool = false) {
    titleLabel.text = .lorem()

    if hasLivePulsing {
      trailingPadding.constant = -66

      configurePulseView()
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.livePulseView.startPulsating()

        NotificationCenter.default.addObserver(
          self,
          selector: #selector(self.startPulsatingView),
          name: UIApplication.willEnterForegroundNotification,
          object: nil
        )

        NotificationCenter.default.addObserver(
          self,
          selector: #selector(self.startPulsatingView),
          name: UIApplication.didEnterBackgroundNotification,
          object: nil
        )
      }
    }
  }

  @objc func startPulsatingView() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.livePulseView.startPulsating()
    }
  }

  @objc func stopPulsatingView() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.livePulseView.stopPulsating()
    }
  }
}

// MARK: Layouts
extension SpaceyTitleCollectionViewCell {
  func configureTitleLabel() {
    contentView.addSubview(titleLabel)

    titleLabel.textColor = YDColors.black
    titleLabel.font = .boldSystemFont(ofSize: 24)
    titleLabel.numberOfLines = 2
    titleLabel.textAlignment = .left

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
      titleLabel.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: 16
      ),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28)
    ])
    trailingPadding.isActive = true
  }

  func configurePulseView() {
    contentView.addSubview(livePulseView)

    livePulseView.backgroundColor = YDColors.Red.night
    livePulseView.layer.cornerRadius = 8

    NSLayoutConstraint.activate([
      livePulseView.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: 9.5
      ),
      livePulseView.widthAnchor.constraint(equalToConstant: 46),
      livePulseView.heightAnchor.constraint(equalToConstant: 16),
      livePulseView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -16
      )
    ])

    // Label
    let message = UILabel()
    livePulseView.addSubview(message)
    message.textColor = .white
    message.textAlignment = .center
    message.font = .systemFont(ofSize: 10)
    message.text = "ao vivo"

    NSLayoutConstraint.activate([
      message.centerXAnchor.constraint(equalTo: livePulseView.centerXAnchor),
      message.centerYAnchor.constraint(equalTo: livePulseView.centerYAnchor)
    ])
  }
}

// MARK: View extension
fileprivate extension UIView {
  func startPulsating() {
    let layerAnim = CALayer()
    layerAnim.frame = self.bounds
    layerAnim.backgroundColor = YDColors.Red.night.cgColor
    layerAnim.cornerRadius = 8

    let layerAnim2 = CALayer()
    layerAnim2.frame = self.bounds
    layerAnim2.backgroundColor = YDColors.Red.night.cgColor
    layerAnim2.cornerRadius = 8

    let fadeOut = CABasicAnimation(keyPath: "opacity")
    fadeOut.fromValue = 0.4
    fadeOut.toValue = 0
    fadeOut.duration = 1.5

    let radiusAnim = CABasicAnimation(keyPath: "cornerRadius")
    radiusAnim.fromValue = 8
    radiusAnim.toValue = [8, 12, 16]
    radiusAnim.duration = 1.5

    let expandScale = CABasicAnimation()
    expandScale.keyPath = "transform"
    expandScale.valueFunction = CAValueFunction(name: CAValueFunctionName.scale)
    expandScale.fromValue = [1, 1, 1]
    expandScale.toValue = [1.5, 2, 1.5]
    expandScale.duration = 1.5

    let fadeAndScale = CAAnimationGroup()
    fadeAndScale.animations = [fadeOut, radiusAnim, expandScale]
    fadeAndScale.duration = 1.5
    fadeAndScale.repeatCount = .infinity
    fadeAndScale.beginTime = CACurrentMediaTime()

    let fadeAndScale2 = CAAnimationGroup()
    fadeAndScale2.animations = [fadeOut, radiusAnim, expandScale]
    fadeAndScale2.duration = 1.5
    fadeAndScale2.repeatCount = .infinity
    fadeAndScale2.beginTime = CACurrentMediaTime() + 0.5

    layerAnim.add(fadeAndScale, forKey: "pulsatingAnimation")
    layerAnim2.add(fadeAndScale2, forKey: "pulsatingAnimation2")

    self.layer.insertSublayer(layerAnim, at: 0)
    self.layer.insertSublayer(layerAnim2, at: 0)
  }

  func stopPulsating() {
//    layer.removeAnimation(forKey: "pulsatingAnimation")
//    layer.removeAnimation(forKey: "pulsatingAnimation2")
//    layer.sublayers?.first(where: { $0.name == "pulsatingAnimation" })?.removeFromSuperlayer()
//    layer.sublayers?.first(where: { $0.name == "pulsatingAnimation2" })?.removeFromSuperlayer()
  }
}
