//
//  YDSnackBarView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 14/01/21.
//

import UIKit

import YDExtensions
import YDB2WColors

public protocol YDSnackBarDelegate: AnyObject {
  func onSnackAction()
}

// MARK: Enum
public enum YDSnackBarType {
  case withButton(buttonName: String)
  case simple
}

public class YDSnackBarView: UIView {
  // MARK: Properties
  public weak var delegate: YDSnackBarDelegate?
  var parent: UIView
  var bottomConstraint: NSLayoutConstraint!
  var removeTimer: Timer?
  var hideTimer: Timer?
  var animateDuration: Double = 0.3
  public var topValue: CGFloat = 0
  public var bottomValue: CGFloat = 100

  // MARK: Life cycle
  public init(parent: UIView) {
    self.parent = parent
    super.init(frame: .zero)

    layer.masksToBounds = false
    layer.applyShadow(blur: 20)
    topValue = parent.safeAreaInsets.bottom
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
  public func showMessage(
    _ message: String,
    ofType type: YDSnackBarType,
    withIcon icon: UIImage? = nil
  ) {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideSnack))
    tapGesture.numberOfTapsRequired = 1
    addGestureRecognizer(tapGesture)

    switch type {
      case .simple:
        buildSimpleLayout(message: message, icon: icon)

      case .withButton(let buttonName):
        buildWithButtonLayout(message: message, buttonName: buttonName, icon: icon)
    }
  }

  private func buildSimpleLayout(message: String, icon: UIImage?) {
    let rect = CGRect(
      x: 0,
      y: 0,
      width: parent.frame.size.width,
      height: 26
    )
    frame = rect
    layer.zPosition = 20
    backgroundColor = YDColors.black
    layer.cornerRadius = 8
    parent.addSubview(self)

    let hasIcon = icon != nil

    let label = createLabel(message)
    addSubview(label)

    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
      label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: hasIcon ? 56 : 21),
      label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -21)
    ])

    if let icon = icon {
      let imageView = createIcon(icon)
      addSubview(imageView)

      imageView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
        imageView.widthAnchor.constraint(equalToConstant: 18),
        imageView.heightAnchor.constraint(equalToConstant: 16)
      ])
    }

    bottomConstraint = bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: bottomValue)

    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bottomConstraint,
      leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 16),
      trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -16)
    ])

    parent.layoutIfNeeded()
    showSnack()
  }

  private func buildWithButtonLayout(message: String, buttonName: String, icon: UIImage?) {
    let rect = CGRect(
      x: 0,
      y: 0,
      width: parent.frame.size.width,
      height: 26
    )
    frame = rect
    layer.zPosition = 20
    backgroundColor = YDColors.black
    layer.cornerRadius = 8
    parent.addSubview(self)

    bottomConstraint = bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: bottomValue)

    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bottomConstraint,
      leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 16),
      trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -16)
    ])

    let hasIcon = icon != nil

    // Label
    let label = createLabel(message)
    addSubview(label)

    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
      label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: hasIcon ? 56 : 21),
      label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -132)
    ])

    // Button
    let button = createButton(buttonName)
    addSubview(button)

    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      button.centerYAnchor.constraint(equalTo: centerYAnchor),
      button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      button.heightAnchor.constraint(equalToConstant: 40)
    ])

    // Icon
    if let icon = icon {
      let imageView = createIcon(icon)
      addSubview(imageView)

      imageView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
        imageView.widthAnchor.constraint(equalToConstant: 22),
        imageView.heightAnchor.constraint(equalToConstant: 20)
      ])
    }

    parent.layoutIfNeeded()
    showSnack()
  }

  @objc private func onButtonAction() {
    delegate?.onSnackAction()
    hideSnack()
  }

  @objc private func showSnack() {
    UIView.animate(withDuration: animateDuration) {
      self.bottomConstraint?.constant = -(self.topValue + 16)
      self.parent.layoutIfNeeded()
    } completion: { _ in
      self.hideTimer?.invalidate()
      self.hideTimer = Timer.scheduledTimer(
        timeInterval: 5,
        target: self,
        selector: #selector(self.hideSnack),
        userInfo: nil,
        repeats: false
      )
    }
  }

  @objc private func hideSnack() {
    hideTimer?.invalidate()
    removeTimer?.invalidate()
    removeTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(removeItSelf), userInfo: nil, repeats: false)

    DispatchQueue.main.async {
      self.parent.layoutIfNeeded()
      self.layoutIfNeeded()
      UIView.animate(withDuration: self.animateDuration) {
        self.bottomConstraint?.constant = (self.frame.size.height + 40)
        self.parent.layoutIfNeeded()
      }
    }
  }

  @objc private func removeItSelf() {
    removeTimer?.invalidate()
    removeFromSuperview()
  }

  private func createLabel(_ message: String) -> UILabel {
    let label = UILabel()
    label.text = message
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = YDColors.Gray.night
    label.textAlignment = .left
    label.numberOfLines = 0
    return label
  }

  private func createIcon(_ image: UIImage) -> UIImageView {
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 18, height: 16))
    imageView.image = image
    imageView.tintColor = .white
    return imageView
  }

  private func createButton(_ title: String) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.setTitleColor(YDColors.Yellow.branding, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    button.addTarget(self, action: #selector(onButtonAction), for: .touchUpInside)
    return button
  }
}
