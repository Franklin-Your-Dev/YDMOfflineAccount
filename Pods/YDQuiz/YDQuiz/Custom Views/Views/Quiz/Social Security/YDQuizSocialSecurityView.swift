//
//  YDQuizSocialSecurityView.swift
//  YDQuiz
//
//  Created by Douglas Hennrich on 28/06/21.
//

import UIKit
import YDB2WModels
import YDExtensions
import YDUtilities
import YDB2WColors

class YDQuizSocialSecurityView: YDQuizView {
  // MARK: Properties
  var stateView: YDUIStateEnum = .normal {
    didSet {
      changeUIState(with: stateView)
    }
  }

  // MARK: Components
  let containerView = UIView()
  let field = UITextField()

  let fieldLabel = UILabel()
  lazy var topLabelConstraint: NSLayoutConstraint = {
    fieldLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 26)
  }()
  lazy var leadingLabelConstraint: NSLayoutConstraint = {
    fieldLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0)
  }()

  let lineView = UIView()
  let errorLabel = UILabel()

  // MARK: Init
  init() {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    endEditing(true)
  }

  // MARK: Configure
  func configure(with quiz: YDB2WModels.YDQuiz) {
    self.quiz = quiz
  }
}

// MARK: UITextField Delegate
extension YDQuizSocialSecurityView: UITextFieldDelegate {
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    guard let text = textField.text else { return false }
    let newString = (text as NSString).replacingCharacters(in: range, with: string)
    textField.text = newString.format(with: "xxx.xxx.xxx-xx", maskOperator: "x")
    
    stateView = .normal

    if (textField.text?.count ?? 0) <= 14 {
      quiz?.storedValue = textField.text
      callback?(quiz)
    }

    if (textField.text?.count ?? 0) == 14 {
      textField.resignFirstResponder()
    }

    return false
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    topLabelConstraint.constant = 0
    leadingLabelConstraint.constant = -10
    UIView.animate(withDuration: 0.3) {
      self.fieldLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
      self.layoutIfNeeded()
    }
  }

  func textFieldDidEndEditing(
    _ textField: UITextField,
    reason: UITextField.DidEndEditingReason
  ) {
    if textField.text?.isEmpty ?? true {
      topLabelConstraint.constant = 26
      leadingLabelConstraint.constant = 0
      UIView.animate(withDuration: 0.3) {
        self.fieldLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.layoutIfNeeded()
      }
    }
  }
}

// MARK: UI
extension YDQuizSocialSecurityView {
  func configureLayout() {
    configureContainerView()
    configureLabel()
    configureTextField()
    configureLine()
    configureErrorLabel()
  }

  private func configureContainerView() {
    addSubview(containerView)
    containerView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: topAnchor),
      containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  private func configureLabel() {
    containerView.addSubview(fieldLabel)
    fieldLabel.textColor = YDColors.Gray.light
    fieldLabel.textAlignment = .left
    fieldLabel.text = "informe seu CPF"
    fieldLabel.font = .systemFont(ofSize: 14)

    fieldLabel.translatesAutoresizingMaskIntoConstraints = false
    topLabelConstraint.isActive = true
    leadingLabelConstraint.isActive = true
    NSLayoutConstraint.activate([
      fieldLabel.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  private func configureTextField() {
    containerView.addSubview(field)
    field.textColor = YDColors.black
    field.tintColor = YDColors.black
    field.font = .systemFont(ofSize: 17)
    field.keyboardType = .numberPad
    field.textAlignment = .left
    field.delegate = self

    field.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      field.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 28),
      field.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      field.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      field.heightAnchor.constraint(equalToConstant: 20)
    ])
  }

  private func configureLine() {
    containerView.addSubview(lineView)
    lineView.backgroundColor = YDColors.Gray.night

    lineView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      lineView.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 6),
      lineView.leadingAnchor.constraint(equalTo: field.leadingAnchor),
      lineView.trailingAnchor.constraint(equalTo: field.trailingAnchor),
      lineView.heightAnchor.constraint(equalToConstant: 1)
    ])
  }

  private func configureErrorLabel() {
    containerView.addSubview(errorLabel)
    errorLabel.textColor = YDColors.Red.night
    errorLabel.font = .systemFont(ofSize: 12)
    errorLabel.text = "Número inválido. Tente novamente."
    errorLabel.textAlignment = .left
    errorLabel.isHidden = true

    errorLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      errorLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 8),
      errorLabel.leadingAnchor.constraint(equalTo: lineView.leadingAnchor),
      errorLabel.trailingAnchor.constraint(equalTo: lineView.trailingAnchor),
      errorLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -1)
    ])
  }
}

// MARK: UIState Delegate
extension YDQuizSocialSecurityView: YDUIStateDelegate {
  func changeUIState(with type: YDUIStateEnum) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      UIView.animate(withDuration: 0.3) {
        self.lineView.backgroundColor = type == .normal ?
          YDColors.Gray.night :
          YDColors.Red.night
        self.errorLabel.isHidden = type == .normal
      }
    }
  }
}
