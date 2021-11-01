//
//  YDQuizConfirmView.swift
//  YDQuiz
//
//  Created by Douglas Hennrich on 29/07/21.
//

import UIKit
import YDB2WModels
import YDExtensions
import YDUtilities
import YDB2WAssets
import YDB2WColors

class YDQuizConfirmView: YDQuizView {
  // MARK: Properties
  var isChecked = false {
    didSet {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.checkBoxButton.backgroundColor = self.isChecked ?
          YDColors.branding :
          nil
        
        self.quiz?.storedValue = self.isChecked ? "checked" : nil
        self.callback?(self.quiz)
      }
    }
  }
  
  // MARK: Components
  let topIcon = UIImageView()
  let titleLabel = UILabel()
  let messageLabel = UILabel()
  
  let vStack = UIStackView()
  let hStack = UIStackView()
  let checkBoxButton = UIButton()
  let checkBoxButtonMessage = UILabel()
  let phantomButton = UIButton()
  
  // MARK: Init
  init() {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Configure
  func configure(with quiz: YDB2WModels.YDQuiz) {
    self.quiz = quiz
  }
  
  // MARK: Actions
  @objc func onCheckBoxToggle() {
    isChecked.toggle()
  }
}

// MARK: UI
extension YDQuizConfirmView {
  private func configureLayout() {
    configureTopIcon()
    configureTitleLabel()
    configureMessageLabel()
    configureStackView()
    configureCheckBox()
    configurePhantomButton()
  }
  
  private func configureTopIcon() {
    addSubview(topIcon)
    topIcon.tintColor = YDColors.Green.done
    topIcon.image = YDAssets.Icons.circleDoneFull

    topIcon.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      topIcon.topAnchor.constraint(equalTo: topAnchor),
      topIcon.widthAnchor.constraint(equalToConstant: 24),
      topIcon.heightAnchor.constraint(equalToConstant: 24),
      topIcon.centerXAnchor.constraint(equalTo: centerXAnchor)
    ])
  }
  
  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.textColor = YDColors.black
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 0
    titleLabel.font = .systemFont(ofSize: 16)
    titleLabel.text = "oooba, seus dados foram confirmados :)"
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topIcon.bottomAnchor, constant: 24),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 42),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -42)
    ])
  }
  
  private func configureMessageLabel() {
    addSubview(messageLabel)
    messageLabel.textColor = YDColors.Gray.light
    messageLabel.textAlignment = .center
    messageLabel.numberOfLines = 0
    messageLabel.font = .systemFont(ofSize: 14)
    messageLabel.text = "agora você terá acesso à todas suas compras nas lojas fisicas aqui no app."
    
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
      messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 42),
      messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -42)
    ])
  }
  
  private func configureStackView() {
    addSubview(vStack)
    vStack.alignment = .center
    vStack.axis = .vertical
    
    vStack.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      vStack.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
      vStack.centerXAnchor.constraint(equalTo: centerXAnchor),
      vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
    ])
    
    vStack.addArrangedSubview(hStack)
    hStack.alignment = .center
    hStack.axis = .horizontal
    hStack.spacing = 6
  }
  
  private func configureCheckBox() {
    hStack.addArrangedSubview(checkBoxButton)
    checkBoxButton.tintColor = .white
    checkBoxButton.setImage(YDAssets.Icons.check, for: .normal)
    checkBoxButton.layer.borderWidth = 1
    checkBoxButton.layer.borderColor = YDColors.Gray.night.cgColor
    checkBoxButton.layer.cornerRadius = 2
    
    let size: CGFloat = 16
    
    checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      checkBoxButton.widthAnchor.constraint(equalToConstant: size),
      checkBoxButton.heightAnchor.constraint(equalToConstant: size)
    ])
    
    hStack.addArrangedSubview(checkBoxButtonMessage)
    checkBoxButtonMessage.textColor = YDColors.Gray.light
    checkBoxButtonMessage.textAlignment = .center
    checkBoxButtonMessage.font = .systemFont(ofSize: 14)
    checkBoxButtonMessage.text = "eu aceito atualizar minhas informacões."
    
    checkBoxButtonMessage.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      checkBoxButtonMessage.heightAnchor.constraint(equalToConstant: 16)
    ])
  }
  
  private func configurePhantomButton() {
    addSubview(phantomButton)
    
    phantomButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      phantomButton.topAnchor.constraint(equalTo: checkBoxButtonMessage.topAnchor),
      phantomButton.leadingAnchor.constraint(equalTo: checkBoxButton.leadingAnchor),
      phantomButton.trailingAnchor
        .constraint(equalTo: checkBoxButtonMessage.trailingAnchor),
      phantomButton.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
    
    phantomButton.addTarget(
      self,
      action: #selector(onCheckBoxToggle),
      for: .touchUpInside
    )
  }
}
