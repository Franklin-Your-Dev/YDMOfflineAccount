//
//  YDCountDownComponentView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 09/06/21.
//

import UIKit
import YDExtensions
import YDB2WColors

class YDCountDownComponentView: UIView {
  // MARK: Enum
  enum NumberType {
    case left
    case left2
    case right
    case right2
  }

  // MARK: Properties
  var currentLeft: NumberType = .left
  var currentLeftNumber = "0"

  var currentRight: NumberType = .right
  var currentRightNumber = "0"

  // MARK: Components
  fileprivate let leftNumberView = NumberView()
  let leftNumberLabel = UILabel()
  lazy var leftNumberCenterYConstraint: NSLayoutConstraint = {
    leftNumberLabel.centerYAnchor.constraint(equalTo: leftNumberView.centerYAnchor)
  }()
  let leftNumberLabel2 = UILabel()
  lazy var leftNumber2CenterYConstraint: NSLayoutConstraint = {
    leftNumberLabel2.centerYAnchor.constraint(equalTo: leftNumberView.centerYAnchor)
  }()

  fileprivate let rightNumberView = NumberView()
  let rightNumberLabel = UILabel()
  lazy var rightNumberCenterYConstraint: NSLayoutConstraint = {
    rightNumberLabel.centerYAnchor.constraint(equalTo: rightNumberView.centerYAnchor)
  }()
  let rightNumberLabel2 = UILabel()
  lazy var rightNumber2CenterYConstraint: NSLayoutConstraint = {
    rightNumberLabel2.centerYAnchor.constraint(equalTo: rightNumberView.centerYAnchor)
  }()

  let descriptionLabel = UILabel()

  // MARK: Init
  init(description: String) {
    super.init(frame: .zero)
    configureUI()
    descriptionLabel.text = description
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
  func update(left: String?, right: String?) {
    if let nextNumber = left,
       currentLeftNumber != nextNumber {
      animateLeftLabel(nextNumber: nextNumber)
    }

    if let nextNumber = right,
       currentRightNumber != nextNumber {
      animateRightLabel(nextNumber: nextNumber)
    }
  }

  func animateLeftLabel(nextNumber: String) {
    currentLeftNumber = nextNumber

    if currentLeft == .left {
      currentLeft = .left2

      leftNumberCenterYConstraint.constant = -50

      leftNumber2CenterYConstraint.constant = 0
      leftNumberLabel2.text = nextNumber

      UIView.animate(withDuration: 0.8) { [weak self] in
        guard let self = self else { return }
        self.leftNumberLabel.alpha = 0
        self.leftNumberView.layoutIfNeeded()
      } completion: { [weak self] _ in
        guard let self = self else { return }

        self.leftNumberCenterYConstraint.constant = 50
        self.leftNumberView.layoutIfNeeded()
        self.leftNumberLabel.alpha = 1
      }

      //
    } else {
      currentLeft = .left

      leftNumber2CenterYConstraint.constant = -50

      leftNumberCenterYConstraint.constant = 0
      leftNumberLabel.text = nextNumber

      UIView.animate(withDuration: 0.8) { [weak self] in
        guard let self = self else { return }
        self.leftNumberLabel2.alpha = 0
        self.leftNumberView.layoutIfNeeded()
      } completion: { [weak self] _ in
        guard let self = self else { return }

        self.leftNumber2CenterYConstraint.constant = 50
        self.leftNumberView.layoutIfNeeded()
        self.leftNumberLabel2.alpha = 1
      }
    }
  }

  func animateRightLabel(nextNumber: String) {
    currentRightNumber = nextNumber

    if currentRight == .right {
      currentRight = .right2

      rightNumberCenterYConstraint.constant = -50

      rightNumber2CenterYConstraint.constant = 0
      rightNumberLabel2.text = nextNumber

      UIView.animate(withDuration: 0.8) { [weak self] in
        guard let self = self else { return }
        self.rightNumberLabel.alpha = 0
        self.rightNumberView.layoutIfNeeded()
      } completion: { [weak self] _ in
        guard let self = self else { return }

        self.rightNumberCenterYConstraint.constant = 50
        self.rightNumberView.layoutIfNeeded()
        self.rightNumberLabel.alpha = 1
      }

      //
    } else {
      currentRight = .right
      rightNumber2CenterYConstraint.constant = -50

      rightNumberCenterYConstraint.constant = 0
      rightNumberLabel.text = nextNumber

      UIView.animate(withDuration: 0.8) { [weak self] in
        guard let self = self else { return }
        self.rightNumberLabel2.alpha = 0
        self.rightNumberView.layoutIfNeeded()
      } completion: { [weak self] _ in
        guard let self = self else { return }
        self.rightNumber2CenterYConstraint.constant = 50
        self.rightNumberView.layoutIfNeeded()
        self.rightNumberLabel2.alpha = 1
      }
    }
  }

  func resetComponent() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      self.currentLeft = .left
      self.currentLeftNumber = "0"
      self.leftNumberLabel.text = "0"
      self.leftNumberLabel.alpha = 1
      self.leftNumberCenterYConstraint.constant = 0
      self.leftNumberLabel2.text = "0"
      self.leftNumberLabel2.alpha = 1
      self.leftNumber2CenterYConstraint.constant = -50
      self.leftNumberView.layoutIfNeeded()

      self.currentRight = .right
      self.currentRightNumber = "0"
      self.rightNumberLabel.text = "0"
      self.rightNumberLabel.alpha = 1
      self.rightNumberCenterYConstraint.constant = 0
      self.rightNumberLabel2.text = "0"
      self.rightNumberLabel2.alpha = 1
      self.rightNumber2CenterYConstraint.constant = -50
      self.rightNumberView.layoutIfNeeded()
    }
  }
}

// MARK: UI
extension YDCountDownComponentView {
  func configureUI() {
    let views = [
      leftNumberView,
      rightNumberView,
      descriptionLabel
    ]

    views.forEach {
      addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    configureLeftView()
    configureRightView()
    configureDescriptionLabel()
  }

  func configureLeftView() {
    NSLayoutConstraint.activate([
      leftNumberView.topAnchor.constraint(equalTo: topAnchor),
      leftNumberView.leadingAnchor.constraint(equalTo: leadingAnchor)
    ])

    // Number Label
    leftNumberView.addSubview(leftNumberLabel)
    leftNumberLabel.font = .boldSystemFont(ofSize: 20)
    leftNumberLabel.textColor = YDColors.Red.night
    leftNumberLabel.textAlignment = .center
    leftNumberLabel.text = "0"

    leftNumberLabel.translatesAutoresizingMaskIntoConstraints = false
    leftNumberCenterYConstraint.isActive = true
    leftNumberLabel.centerXAnchor
      .constraint(equalTo: leftNumberView.centerXAnchor).isActive = true

    // Number Label 2
    leftNumberView.addSubview(leftNumberLabel2)
    leftNumberLabel2.font = .boldSystemFont(ofSize: 20)
    leftNumberLabel2.textColor = YDColors.Red.night
    leftNumberLabel2.textAlignment = .center
    leftNumberLabel2.text = "0"

    leftNumberLabel2.translatesAutoresizingMaskIntoConstraints = false
    leftNumber2CenterYConstraint.isActive = true
    leftNumber2CenterYConstraint.constant = 45
    leftNumberLabel2.centerXAnchor
      .constraint(equalTo: leftNumberView.centerXAnchor).isActive = true
  }

  func configureRightView() {
    NSLayoutConstraint.activate([
      rightNumberView.topAnchor.constraint(equalTo: topAnchor),
      rightNumberView.leadingAnchor
        .constraint(equalTo: leftNumberView.trailingAnchor, constant: 2),
      rightNumberView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])

    // Number Label
    rightNumberView.addSubview(rightNumberLabel)
    rightNumberLabel.font = .boldSystemFont(ofSize: 20)
    rightNumberLabel.textColor = YDColors.Red.night
    rightNumberLabel.textAlignment = .center
    rightNumberLabel.text = "0"

    rightNumberLabel.translatesAutoresizingMaskIntoConstraints = false
    rightNumberCenterYConstraint.isActive = true
    rightNumberLabel.centerXAnchor
      .constraint(equalTo: rightNumberView.centerXAnchor).isActive = true

    // Number Label 2
    rightNumberView.addSubview(rightNumberLabel2)
    rightNumberLabel2.font = .boldSystemFont(ofSize: 20)
    rightNumberLabel2.textColor = YDColors.Red.night
    rightNumberLabel2.textAlignment = .center
    rightNumberLabel2.text = "0"

    rightNumberLabel2.translatesAutoresizingMaskIntoConstraints = false
    rightNumber2CenterYConstraint.isActive = true
    rightNumber2CenterYConstraint.constant = 45
    rightNumberLabel2.centerXAnchor
      .constraint(equalTo: rightNumberView.centerXAnchor).isActive = true
  }

  func configureDescriptionLabel() {
    descriptionLabel.textColor = YDColors.Gray.light
    descriptionLabel.textAlignment = .center
    descriptionLabel.font = .systemFont(ofSize: 10, weight: .medium)

    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: leftNumberView.bottomAnchor, constant: 6),
      descriptionLabel.leadingAnchor.constraint(equalTo: leftNumberView.leadingAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: rightNumberView.trailingAnchor),
      descriptionLabel.heightAnchor.constraint(equalToConstant: 12),
      descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
}

//
fileprivate class NumberView: UIView {
  // MARK: Init
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init() {
    super.init(frame: .zero)
    backgroundColor = YDColors.Red.pale
    layer.cornerRadius = 2
    clipsToBounds = true
    translatesAutoresizingMaskIntoConstraints = false
    widthAnchor.constraint(equalToConstant: 24).isActive = true
    heightAnchor.constraint(equalToConstant: 34).isActive = true
  }
}
