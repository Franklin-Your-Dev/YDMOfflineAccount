//
//  YDQuizIndicatorView.swift
//  YDQuiz
//
//  Created by Douglas Hennrich on 01/07/21.
//

import UIKit
import YDExtensions
import YDB2WModels
import YDB2WColors

class YDQuizIndicatorView: UIView {
  // MARK: Properties
  var indicators: [YDQuizIndicatorSphereView] = []

  // MARK: Components
  let centerLine = UIView()
  let vStack = UIStackView()
  let hStack = UIStackView()

  // MARK: Init
  init() {
    super.init(frame: .zero)
    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configure
  func configure(howMany: Int) {
    indicators.removeAll()
    hStack.subviews.forEach { hStack.removeArrangedSubview($0) }
    
    for _ in 1...howMany {
      let indicator = YDQuizIndicatorSphereView()
      indicators.append(indicator)
      hStack.addArrangedSubview(indicator)
    }
  }
}

// MARK: UI
extension YDQuizIndicatorView {
  private func configureLayout() {
    translatesAutoresizingMaskIntoConstraints = false
    heightAnchor.constraint(equalToConstant: 12).isActive = true

    configureCenterLine()
    configureVerticalStack()
    configureHorizontalStack()
  }

  private func configureCenterLine() {
    addSubview(centerLine)
    centerLine.backgroundColor = YDColors.Gray.night

    centerLine.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      centerLine.heightAnchor.constraint(equalToConstant: 1),
      centerLine.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }

  private func configureVerticalStack() {
    addSubview(vStack)
    vStack.axis = .vertical
    vStack.alignment = .center

    vStack.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      vStack.topAnchor.constraint(equalTo: topAnchor),
      vStack.leadingAnchor.constraint(equalTo: leadingAnchor),
      vStack.trailingAnchor.constraint(equalTo: trailingAnchor),
      vStack.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  private func configureHorizontalStack() {
    vStack.addArrangedSubview(hStack)
    hStack.axis = .horizontal
    hStack.alignment = .center
    hStack.spacing = 21
    hStack.distribution = .equalCentering

    hStack.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      hStack.topAnchor.constraint(equalTo: topAnchor),
      hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
      hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
      hStack.bottomAnchor.constraint(equalTo: bottomAnchor),

      centerLine.leadingAnchor.constraint(equalTo: hStack.leadingAnchor, constant: 5),
      centerLine.trailingAnchor.constraint(equalTo: hStack.trailingAnchor, constant: -5)
    ])
  }
}
