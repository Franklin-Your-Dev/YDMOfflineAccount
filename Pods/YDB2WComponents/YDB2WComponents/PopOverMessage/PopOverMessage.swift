//
//  PopOverMessage.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 01/04/21.
//

import UIKit
import YDB2WAssets
import YDExtensions
import YDB2WColors

public class YDPopOverMessage: UIViewController {
  // MARK: Properties
  var timer: Timer?

  // MARK: Components
  let container = UIView()
  let iconImageView = UIImageView()
  let messageLabel = UILabel()

  // MARK: View life cycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    setUpLayout()
  }

  // MARK: Action
  public static func show(_ message: String, icon: UIImage?) {
    let topViewController = UIApplication.shared.keyWindow?
      .rootViewController?.topMostViewController()

    let viewController = YDPopOverMessage()

    if let icon = icon {
      viewController.iconImageView.image = icon
    }

    viewController.messageLabel.text = message

    viewController.modalPresentationStyle = .overCurrentContext
    topViewController?.present(viewController, animated: true, completion: {
      viewController.timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
        viewController.dismiss(animated: true)
      })
    })
  }

  @objc private func onTapAction() {
    timer?.invalidate()
    dismiss(animated: true)
  }
}

// MARK: Layout
extension YDPopOverMessage {
  private func setUpLayout() {
    createContainer()
    createBlur()
    createIconImageView()
    createMessageLabel()
  }

  private func createContainer() {
    container.backgroundColor = YDColors.Gray.opaque.withAlphaComponent(0.8)
    container.layer.cornerRadius = 14
    view.addSubview(container)

    container.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      container.widthAnchor.constraint(equalToConstant: 216)
    ])

    container.addGestureRecognizer(
      UITapGestureRecognizer(target: self, action: #selector(onTapAction))
    )
  }

  private func createBlur() {
    let blur = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blur)
    container.addSubview(blurView)

    blurView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      blurView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
      blurView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
      blurView.topAnchor.constraint(equalTo: container.topAnchor),
      blurView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
    ])

    blurView.layer.cornerRadius = 14
    blurView.clipsToBounds = true
  }

  private func createIconImageView() {
    iconImageView.tintColor = YDColors.black
    iconImageView.image = YDAssets.Icons.circleDone
    container.addSubview(iconImageView)

    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      iconImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 32),
      iconImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
      iconImageView.widthAnchor.constraint(equalToConstant: 100),
      iconImageView.heightAnchor.constraint(equalToConstant: 100)
    ])
  }

  private func createMessageLabel() {
    messageLabel.font = .systemFont(ofSize: 20, weight: .semibold)
    messageLabel.textColor = YDColors.black
    messageLabel.textAlignment = .center
    messageLabel.numberOfLines = 0
    container.addSubview(messageLabel)

    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
      messageLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
      messageLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
      messageLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24)
    ])
  }
}
