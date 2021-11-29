//
//  SpaceyEditTextCollectionViewCell.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 03/11/21.
//

import UIKit

import YDB2WModels
import YDExtensions
import YDB2WColors

class SpaceyEditTextCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  private let padding: CGFloat = 16
  var callback: ((_ answer: String?) -> Void)?
  var maxCharacters = 0

  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()
  
  let containerView = UIView()
  
  let titleWithOptionalView = YDSpaceyNPSTitleWithOptionalView()
  
  let editText = YDTextView()
  
  let charactersCountLabel = UILabel()

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func systemLayoutSizeFitting(
    _ targetSize: CGSize,
    withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
    verticalFittingPriority: UILayoutPriority
  ) -> CGSize {
    width.constant = bounds.size.width
    return contentView.systemLayoutSizeFitting(
      CGSize(width: targetSize.width, height: 1)
    )
  }

  // MARK: Actions
  func configure(with component: YDSpaceyComponentNPSQuestion) {
    maxCharacters = component.maxCharacter ?? 150
    charactersCountLabel.text = "máximo de \(maxCharacters) caracteres"
    editText.placeHolder = component.hint ?? ""
    
    titleWithOptionalView.configure(with: component)
    titleWithOptionalView.titleLabel.text = "deixe um comentário"
  }
}

// MARK: Layout
extension SpaceyEditTextCollectionViewCell {
  func configureLayout() {
    configureContainerView()
    configureTitleWithOptionalView()
    configureEditText()
    configureCountLabel()
  }
  
  private func configureContainerView() {
    contentView.addSubview(containerView)
    containerView.backgroundColor = .white
    containerView.layer.cornerRadius = 12
    containerView.layer.applyShadow(y: 1, blur: 8, spread: -1)
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      containerView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -padding
      ),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
    ])
  }
  
  private func configureTitleWithOptionalView() {
    containerView.addSubview(titleWithOptionalView)
    
    NSLayoutConstraint.activate([
      titleWithOptionalView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
      titleWithOptionalView.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor,
        constant: padding
      ),
      titleWithOptionalView.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant: -padding
      )
    ])
  }
  
  private func configureEditText() {
    containerView.addSubview(editText)
    editText.delegate = self
    editText.tintColor = YDColors.Gray.light
    editText.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      editText.topAnchor.constraint(
        equalTo: titleWithOptionalView.bottomAnchor,
        constant: 8
      ),
      editText.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
      editText.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor,
        constant:  -padding
      )
    ])
  }

  private func configureCountLabel() {
    containerView.addSubview(charactersCountLabel)
    charactersCountLabel.font = .systemFont(ofSize: 12)
    charactersCountLabel.textColor = YDColors.Gray.light
    charactersCountLabel.textAlignment = .left

    charactersCountLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      charactersCountLabel.topAnchor.constraint(equalTo: editText.bottomAnchor, constant: 4),
      charactersCountLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 22),
      charactersCountLabel.trailingAnchor.constraint(equalTo: editText.trailingAnchor),
      charactersCountLabel.heightAnchor.constraint(equalToConstant: padding),
      charactersCountLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
    ])
  }
}

// MARK: Text View Delegate
extension SpaceyEditTextCollectionViewCell: YDTextViewDelegate {
  func onNextButtonYDTextView(_ value: String?) {}

  func textViewDidChangeSelection(_ textView: UITextView) {
    if textView.text == editText.placeHolder {
//      charactersCountLabel.text = "máximo de \(maxCharacters) caracteres"

    } else {
//      charactersCountLabel.text = "\(textView.text.count)/\(maxCharacters)"

      callback?(textView.text)
    }
  }

  func shouldChangeText(
    _ textView: UITextView,
    shouldChangeTextIn range: NSRange,
    replacementText text: String
  ) -> Bool {
    let currentText = textView.text ?? ""

    // attempt to read the range they are trying to change, or exit if we can't
    guard let stringRange = Range(range, in: currentText) else { return false }

    // add their new text to the existing text
    let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

    // make sure the result is under 16 characters
    return updatedText.count <= maxCharacters
  }
}
