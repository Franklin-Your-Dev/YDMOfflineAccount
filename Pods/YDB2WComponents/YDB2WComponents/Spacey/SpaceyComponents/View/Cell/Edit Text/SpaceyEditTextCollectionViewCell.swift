//
//  SpaceyEditTextCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 01/06/21.
//

import UIKit

import YDB2WModels
import YDExtensions
import YDB2WColors

class SpaceyEditTextCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  var callback: ((_ answer: String?) -> Void)?
  var maxCharacters = 0

  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()
  let charactersCountLabel = UILabel()
  let editText = YDTextView()

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
    charactersCountLabel.text = "0/\(maxCharacters)"
    editText.placeHolder = component.hint ?? ""
  }
}

// MARK: Layout
extension SpaceyEditTextCollectionViewCell {
  func configureLayout() {
    configureCountLabel()
    configureEditText()
  }

  func configureCountLabel() {
    contentView.addSubview(charactersCountLabel)
    charactersCountLabel.font = .systemFont(ofSize: 14)
    charactersCountLabel.textColor = YDColors.Gray.light
    charactersCountLabel.textAlignment = .right

    charactersCountLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      charactersCountLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      charactersCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      charactersCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      charactersCountLabel.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  func configureEditText() {
    contentView.addSubview(editText)
    editText.delegate = self
    editText.tintColor = YDColors.Gray.light
    editText.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      editText.topAnchor.constraint(
        equalTo: charactersCountLabel.bottomAnchor,
        constant: 6
      ),
      editText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      editText.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant:  -16
      ),
      editText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1)
    ])
  }
}

// MARK: Text View Delegate
extension SpaceyEditTextCollectionViewCell: YDTextViewDelegate {
  func onNextButtonYDTextView(_ value: String?) {}

  func textViewDidChangeSelection(_ textView: UITextView) {
    if textView.text == editText.placeHolder {
      charactersCountLabel.text = "0/\(maxCharacters)"

    } else {
      charactersCountLabel.text = "\(textView.text.count)/\(maxCharacters)"

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
