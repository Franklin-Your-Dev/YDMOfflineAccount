//
//  YDNeedHelpViewController+Layouts.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 29/09/21.
//

import UIKit
import YDB2WAssets
import YDExtensions
import YDB2WColors

extension YDNeedHelpViewController {
  func configureUI() {
    view.backgroundColor = .white
    
    configureNavBar()
    configureLogo()
    configureTitleLabel()
    configureDescriptionLabel()
    
    configureBackButton()
    configureOpenFormButton()
  }
  
  private func configureNavBar() {
    let closeButton = UIBarButtonItem(
      title: "fechar",
      style: .plain,
      target: self,
      action: #selector(onCloseAction)
    )
    
    navigationItem.rightBarButtonItem = closeButton
  }
  
  private func configureLogo() {
    view.addSubview(logoContainer)
    logoContainer.backgroundColor = YDColors.branding
    logoContainer.layer.cornerRadius = 6
    logoContainer.layer.applyShadow()
    
    logoContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      logoContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenPadding),
      logoContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenPadding),
      logoContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenPadding),
      logoContainer.heightAnchor.constraint(equalToConstant: 118)
    ])
    
    // Logo
    logoContainer.addSubview(logoImageView)
    logoImageView.tintColor = .white
    logoImageView.image = YDAssets.Icons.logoSmall
    
    let logoPadding: CGFloat = 64
    
    logoImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      logoImageView.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor),
      logoImageView.leadingAnchor.constraint(equalTo: logoContainer.leadingAnchor, constant: logoPadding),
      logoImageView.trailingAnchor.constraint(equalTo: logoContainer.trailingAnchor, constant: -logoPadding),
      logoImageView.heightAnchor.constraint(equalToConstant: 38)
    ])
  }
  
  private func configureTitleLabel() {
    view.addSubview(titleLabel)
    titleLabel.textColor = YDColors.black
    titleLabel.font = .boldSystemFont(ofSize: 20)
    titleLabel.textAlignment = .center
    titleLabel.text = "ei, precisa de ajuda?"
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: logoContainer.bottomAnchor, constant: 32),
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenPadding),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenPadding)
    ])
  }
  
  private func configureDescriptionLabel() {
    view.addSubview(descriptionLabel)
    descriptionLabel.textColor = YDColors.Gray.light
    descriptionLabel.font = .systemFont(ofSize: 14)
    descriptionLabel.textAlignment = .center
    descriptionLabel.text = "Preencha o formulário e aguarde que em breve a gente fala com você ;)"
    descriptionLabel.numberOfLines = 2
    
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenPadding),
      descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenPadding)
    ])
  }
  
  private func configureBackButton() {
    view.addSubview(backButton)
    backButton.layer.cornerRadius = 4
    
    NSLayoutConstraint.activate([
      backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -52),
      backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenPadding),
      backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenPadding)
    ])
    
    backButton.callback = { [weak self] _ in
      guard let self = self else { return }
      self.onCloseAction()
    }
  }
  
  private func configureOpenFormButton() {
    view.addSubview(openFormButton)
    openFormButton.backgroundColor = YDColors.branding
    openFormButton.layer.cornerRadius = 4
    openFormButton.setTitle("preencher formulário", for: .normal)
    openFormButton.setTitleColor(UIColor.white, for: .normal)
    
    openFormButton.addTarget(self, action: #selector(onOpenFormAction), for: .touchUpInside)
    
    openFormButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      openFormButton.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -16),
      openFormButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenPadding),
      openFormButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenPadding),
      openFormButton.heightAnchor.constraint(equalToConstant: 40)
    ])
  }
}
