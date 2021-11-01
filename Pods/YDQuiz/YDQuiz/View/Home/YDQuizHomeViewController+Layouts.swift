//
//  YDQuizHomeViewController+Layouts.swift
//  YDQuiz
//
//  Created by Douglas Hennrich on 27/06/21.
//

import UIKit
import YDB2WAssets
import YDExtensions
import YDB2WColors

extension YDQuizHomeViewController {
  func configureLayout() {
    view.backgroundColor = .white

    configureNavBar()
    configureDescriptionLabel()
    configureIndicatorView()
    configureScrollView()
    configureStackView()
    configureButtonsContainer()
    configureNextButton()
    configureErrorView()

    configureShimmers()
  }

  private func configureNavBar() {
    navLeftButton = UIBarButtonItem(
      image: YDAssets.Icons.info,
      style: .plain,
      target: self,
      action: #selector(onInfoAction)
    )

    navigationItem.leftBarButtonItem = navLeftButton

    navRightButton = UIBarButtonItem()
    navRightButton?.customView = createNavRightView()
    navigationItem.rightBarButtonItem = navRightButton
  }

  private func createNavRightView() -> UIView {
    let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
    rightButton.backgroundColor = .white
    rightButton.layer.cornerRadius = 16
    rightButton.layer.applyShadow()
    rightButton.tintColor = YDColors.Gray.light
    rightButton.setImage(YDAssets.Icons.times, for: .normal)
    rightButton.addTarget(self, action: #selector(onExitAction), for: .touchUpInside)
    return rightButton
  }

  private func configureDescriptionLabel() {
    view.addSubview(descriptionLabel)
    descriptionLabel.font = .systemFont(ofSize: 16)
    descriptionLabel.textColor = YDColors.Gray.light
    descriptionLabel.textAlignment = .center
    descriptionLabel.numberOfLines = 0
    descriptionLabel.text = "pra garantir a segurança dos seus dados precisamos confirmar algumas informacões, vamos lá? :)"

    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor
        .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
      descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
    ])
  }

  private func configureIndicatorView() {
    view.addSubview(indicatorView)

    indicatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      indicatorView.topAnchor
        .constraint(equalTo: descriptionLabel.bottomAnchor, constant: 38),
      indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }

  private func configureScrollView() {
    view.addSubview(scrollView)
    scrollView.isPagingEnabled = true
    scrollView.isScrollEnabled = false

    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    scrollViewTopAnchor.isActive = true
    NSLayoutConstraint.activate([
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }

  private func configureStackView() {
    scrollView.addSubview(stackView)
    stackView.axis = .horizontal
    stackView.alignment = .leading
    stackView.spacing = 0

    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackViewHeightConstraint.constant = 100

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

      scrollView.heightAnchor.constraint(equalTo: stackView.heightAnchor)
    ])
  }

  private func configureButtonsContainer() {
    view.addSubview(buttonsContainer)

    buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      buttonsContainer.topAnchor
        .constraint(equalTo: scrollView.bottomAnchor, constant: 30),
      buttonsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      buttonsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      buttonsContainer.heightAnchor.constraint(equalToConstant: 40)
    ])
  }

  private func configureNextButton() {
    buttonsContainer.addSubview(nextButton)
    nextButton.callback = onNextAction
    nextButton.setEnabled(false)

    NSLayoutConstraint.activate([
      nextButton.trailingAnchor.constraint(equalTo: buttonsContainer.trailingAnchor, constant: -16),
      nextButton.centerYAnchor.constraint(equalTo: buttonsContainer.centerYAnchor)
    ])
  }
  
  private func configureErrorView() {
    view.addSubview(errorView)
    
    NSLayoutConstraint.activate([
      errorView.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 62),
      errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    
    errorView.callback = onErrorViewButtonAction
  }
}

// MARK: Shimmers
extension YDQuizHomeViewController {
  private func configureShimmers() {
    configureDescriptionShimmer()
    configureIndicatorViewShimmer()
    configureButtonsShimmers()
    configureFirstShimmers()
    configureSecondShimmers()
  }

  private func configureDescriptionShimmer() {
    [descriptionShimmer, descriptionShimmer2, descriptionShimmer3].forEach {
      view.addSubview($0)
      commonShimmers.append($0)
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 4
      $0.isHidden = true

      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.heightAnchor.constraint(equalToConstant: 13).isActive = true
      $0.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    NSLayoutConstraint.activate([
      descriptionShimmer.topAnchor
        .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
      descriptionShimmer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 82),
      descriptionShimmer.trailingAnchor
        .constraint(equalTo: view.trailingAnchor, constant: -82),

      descriptionShimmer2.topAnchor
        .constraint(equalTo: descriptionShimmer.bottomAnchor, constant: 7),
      descriptionShimmer2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 62),
      descriptionShimmer2.trailingAnchor
        .constraint(equalTo: view.trailingAnchor, constant: -62),

      descriptionShimmer3.topAnchor
        .constraint(equalTo: descriptionShimmer2.bottomAnchor, constant: 7),
      descriptionShimmer3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 92),
      descriptionShimmer3.trailingAnchor
        .constraint(equalTo: view.trailingAnchor, constant: -92)
    ])
  }
  
  private func configureIndicatorViewShimmer() {
    view.addSubview(indicatorViewShimmer)
    commonShimmers.append(indicatorViewShimmer)
    indicatorViewShimmer.backgroundColor = .white
    indicatorViewShimmer.layer.cornerRadius = 4
    indicatorViewShimmer.isHidden = true

    indicatorViewShimmer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      indicatorViewShimmer.topAnchor
        .constraint(equalTo: descriptionShimmer3.bottomAnchor, constant: 42),
      indicatorViewShimmer.heightAnchor.constraint(equalToConstant: 13),
      indicatorViewShimmer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      indicatorViewShimmer.leadingAnchor.constraint(equalTo: indicatorView.leadingAnchor),
      indicatorViewShimmer.trailingAnchor
        .constraint(equalTo: indicatorView.trailingAnchor)
    ])
  }

  private func configureButtonsShimmers() {
    view.addSubview(nextButtonShimmer)
    commonShimmers.append(nextButtonShimmer)
    nextButtonShimmer.backgroundColor = .white
    nextButtonShimmer.layer.cornerRadius = 4
    nextButtonShimmer.isHidden = true

    nextButtonShimmer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      nextButtonShimmer.heightAnchor.constraint(equalToConstant: 40),
      nextButtonShimmer.topAnchor.constraint(equalTo: buttonsContainer.topAnchor),
      nextButtonShimmer.leadingAnchor.constraint(equalTo: nextButton.leadingAnchor),
      nextButtonShimmer.trailingAnchor.constraint(equalTo: nextButton.trailingAnchor)
    ])
  }

  private func configureFirstShimmers() {
    [firstShimmerView, firstShimmerView2].forEach {
      view.addSubview($0)
      firstShimmers.append($0)
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 4
      $0.isHidden = true

      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.heightAnchor.constraint(equalToConstant: 13).isActive = true
      $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    }

    NSLayoutConstraint.activate([
      firstShimmerView.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 30),
      firstShimmerView.widthAnchor.constraint(equalToConstant: 102),

      firstShimmerView2.topAnchor
        .constraint(equalTo: firstShimmerView.bottomAnchor, constant: 7),
      firstShimmerView2.trailingAnchor
        .constraint(equalTo: view.trailingAnchor, constant: -16)
    ])
  }
  
  private func configureSecondShimmers() {
    [
      secondShimmerView,
      secondShimmerView2,
      secondShimmerView3,
      secondShimmerView4
    ].forEach {
      view.addSubview($0)
      secondShimmers.append($0)
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 4
      $0.isHidden = true

      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
      $0.heightAnchor.constraint(equalToConstant: 13).isActive = true
      
      if $0 != secondShimmerView {
        $0.widthAnchor.constraint(equalToConstant: 16).isActive = true
      }
    }
    
    [
      secondShimmerView22,
      secondShimmerView32,
      secondShimmerView42
    ].forEach {
      view.addSubview($0)
      secondShimmers.append($0)
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 4
      $0.isHidden = true

      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.heightAnchor.constraint(equalToConstant: 13).isActive = true
    }

    NSLayoutConstraint.activate([
      secondShimmerView.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 30),
      secondShimmerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

      secondShimmerView2.topAnchor.constraint(equalTo: secondShimmerView.bottomAnchor, constant: 30),
      secondShimmerView22.leadingAnchor
        .constraint(equalTo: secondShimmerView2.trailingAnchor, constant: 12),
      secondShimmerView22.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -177),
      secondShimmerView22.centerYAnchor.constraint(equalTo: secondShimmerView2.centerYAnchor),
      
      secondShimmerView3.topAnchor.constraint(equalTo: secondShimmerView2.bottomAnchor, constant: 16),
      secondShimmerView32.leadingAnchor
        .constraint(equalTo: secondShimmerView3.trailingAnchor, constant: 12),
      secondShimmerView32.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -218),
      secondShimmerView32.centerYAnchor.constraint(equalTo: secondShimmerView3.centerYAnchor),
      
      secondShimmerView4.topAnchor.constraint(equalTo: secondShimmerView3.bottomAnchor, constant: 16),
      secondShimmerView42.leadingAnchor
        .constraint(equalTo: secondShimmerView4.trailingAnchor, constant: 12),
      secondShimmerView42.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -146),
      secondShimmerView42.centerYAnchor.constraint(equalTo: secondShimmerView4.centerYAnchor)
    ])
  }
}
