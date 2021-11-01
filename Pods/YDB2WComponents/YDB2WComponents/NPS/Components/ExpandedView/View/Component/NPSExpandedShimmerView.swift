//
//  NPSExpandedShimmerView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 20/10/21.
//

import UIKit
import YDExtensions

public class YDNPSExpandedShimmerView: UIView {
  // MARK: Properties
  var views: [UIView] = []

  // MARK: Components
  let view1 = UIView()
  let view2 = UIView()
  let view3 = UIView()
  let view4 = UIView()
  let view5 = UIView()
  let view6 = UIView()
  let view7 = UIView()
  let view7b = UIView()
  let view8 = UIView()
  let view8b = UIView()
  let view9 = UIView()
  let view9b = UIView()
  let view10 = UIView()
  let view10b = UIView()
  let view11 = UIView()
  let view12 = UIView()

  // MARK: Init
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override init(frame: CGRect) {
    super.init(frame: .zero)
    configure()
  }

  public init() {
    super.init(frame: .zero)
    configure()
  }

  // MARK: Actions
  public func startShimmers() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.views.forEach { $0.startShimmer() }
    }
  }

  public func stopShimmers() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.views.forEach { $0.stopShimmer() }
    }
  }
}

// MARK: UI
extension YDNPSExpandedShimmerView {
  func configure() {
    translatesAutoresizingMaskIntoConstraints = false
    configureView1()
    configureView2()
    configureView3()
    configureView4()
    configureView5()
    configureView6()
    configureView7()
    configureView8()
    configureView9()
    configureView10()
    configureView11()
    configureView12()

    views.forEach {
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 4
    }
  }

  func configureView1() {
    addSubview(view1)
    views.append(view1)
    view1.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view1.topAnchor.constraint(equalTo: topAnchor),
      view1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      view1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -120),
      view1.heightAnchor.constraint(equalToConstant: 24)
    ])
  }

  func configureView2() {
    addSubview(view2)
    views.append(view2)
    view2.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view2.topAnchor.constraint(equalTo: view1.bottomAnchor, constant: 14),
      view2.centerXAnchor.constraint(equalTo: centerXAnchor),
      view2.widthAnchor.constraint(equalToConstant: 248),
      view2.heightAnchor.constraint(equalToConstant: 24)
    ])
  }

  func configureView3() {
    addSubview(view3)
    views.append(view3)
    view3.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view3.topAnchor.constraint(equalTo: view2.bottomAnchor, constant: 16),
      view3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      view3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -240),
      view3.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  func configureView4() {
    addSubview(view4)
    views.append(view4)
    view4.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view4.topAnchor.constraint(equalTo: view3.bottomAnchor, constant: 76),
      view4.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      view4.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -68),
      view4.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  func configureView5() {
    addSubview(view5)
    views.append(view5)
    view5.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view5.topAnchor.constraint(equalTo: view4.bottomAnchor, constant: 16),
      view5.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      view5.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      view5.heightAnchor.constraint(equalToConstant: 32)
    ])
  }

  func configureView6() {
    addSubview(view6)
    views.append(view6)
    view6.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view6.topAnchor.constraint(equalTo: view5.bottomAnchor, constant: 20),
      view6.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      view6.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -68),
      view6.heightAnchor.constraint(equalToConstant: 32)
    ])
  }

  func configureView7() {
    addSubview(view7)
    views.append(view7)
    view7.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view7.topAnchor.constraint(equalTo: view6.bottomAnchor, constant: 18),
      view7.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      view7.widthAnchor.constraint(equalToConstant: 22),
      view7.heightAnchor.constraint(equalToConstant: 18)
    ])

    addSubview(view7b)
    views.append(view7b)
    view7b.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view7b.centerYAnchor.constraint(equalTo: view7.centerYAnchor),
      view7b.leadingAnchor.constraint(equalTo: view7.trailingAnchor, constant: 12),
      view7b.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -134),
      view7b.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  func configureView8() {
    addSubview(view8)
    views.append(view8)
    view8.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view8.topAnchor.constraint(equalTo: view7.bottomAnchor, constant: 12),
      view8.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      view8.widthAnchor.constraint(equalToConstant: 22),
      view8.heightAnchor.constraint(equalToConstant: 18)
    ])

    addSubview(view8b)
    views.append(view8b)
    view8b.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view8b.centerYAnchor.constraint(equalTo: view8.centerYAnchor),
      view8b.leadingAnchor.constraint(equalTo: view8.trailingAnchor, constant: 12),
      view8b.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -72),
      view8b.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  func configureView9() {
    addSubview(view9)
    views.append(view9)
    view9.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view9.topAnchor.constraint(equalTo: view8.bottomAnchor, constant: 12),
      view9.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      view9.widthAnchor.constraint(equalToConstant: 22),
      view9.heightAnchor.constraint(equalToConstant: 18)
    ])

    addSubview(view9b)
    views.append(view9b)
    view9b.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view9b.centerYAnchor.constraint(equalTo: view9.centerYAnchor),
      view9b.leadingAnchor.constraint(equalTo: view9.trailingAnchor, constant: 12),
      view9b.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -178),
      view9b.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  func configureView10() {
    addSubview(view10)
    views.append(view10)
    view10.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view10.topAnchor.constraint(equalTo: view9.bottomAnchor, constant: 12),
      view10.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      view10.widthAnchor.constraint(equalToConstant: 22),
      view10.heightAnchor.constraint(equalToConstant: 18)
    ])

    addSubview(view10b)
    views.append(view10b)
    view10b.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view10b.centerYAnchor.constraint(equalTo: view10.centerYAnchor),
      view10b.leadingAnchor.constraint(equalTo: view10.trailingAnchor, constant: 12),
      view10b.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -142),
      view10b.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  func configureView11() {
    addSubview(view11)
    views.append(view11)
    view11.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view11.topAnchor
        .constraint(greaterThanOrEqualTo: view10.bottomAnchor, constant: 20),
      view11.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      view11.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      view11.heightAnchor.constraint(equalToConstant: 38)
    ])
    view11.setContentHuggingPriority(.defaultLow, for: .vertical)
  }

  func configureView12() {
    addSubview(view12)
    views.append(view12)
    view12.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view12.topAnchor
        .constraint(equalTo: view11.bottomAnchor, constant: 20),
      view12.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      view12.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      view12.heightAnchor.constraint(equalToConstant: 42),
      view12.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
    ])
    view12.setContentHuggingPriority(.defaultHigh, for: .vertical)
  }
}

