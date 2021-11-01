//
//  YDQuizIndicatorSphereView.swift
//  YDQuiz
//
//  Created by Douglas Hennrich on 02/07/21.
//

import UIKit
import YDExtensions
import YDB2WAssets
import YDB2WColors

class YDQuizIndicatorSphereView: UIView {
  // MARK: Properties
  var highlighted = false {
    didSet {
      changeState()
    }
  }

  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    widthAnchor.constraint(equalToConstant: 12)
  }()
  lazy var height: NSLayoutConstraint = {
    heightAnchor.constraint(equalToConstant: 12)
  }()

  let icon = UIImageView()

  // MARK: Init
  init() {
    super.init(frame: .zero)
    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
  func changeState() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      if self.highlighted {
        self.icon.isHidden = false
        self.layer.borderColor = nil
        self.layer.borderWidth = 0
      } else {
        self.icon.isHidden = true
        self.layer.borderColor = YDColors.Gray.night.cgColor
      }
    }
  }
}

// MARK: UI
extension YDQuizIndicatorSphereView {
  private func configureLayout() {
    translatesAutoresizingMaskIntoConstraints = false
    width.isActive = true
    height.isActive = true

    layer.cornerRadius = 6
    layer.borderWidth = 1
    layer.borderColor = YDColors.Gray.night.cgColor
    backgroundColor = .white

    configureIcon()
  }

  private func configureIcon() {
    addSubview(icon)
    icon.tintColor = YDColors.Green.done
    icon.image = YDAssets.Icons.circleDoneFull
    icon.isHidden = true

    icon.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      icon.centerXAnchor.constraint(equalTo: centerXAnchor),
      icon.centerYAnchor.constraint(equalTo: centerYAnchor),
      icon.widthAnchor.constraint(equalToConstant: 24),
      icon.heightAnchor.constraint(equalToConstant: 24)
    ])
  }
}

