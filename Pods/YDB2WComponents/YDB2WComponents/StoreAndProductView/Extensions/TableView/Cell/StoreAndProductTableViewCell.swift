//
//  StoreAndProductTableViewCell.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 26/03/21.
//

import UIKit

import YDExtensions
import YDB2WModels
import YDB2WColors

class StoreAndProductTableViewCell: UITableViewCell {
  // MARK: Components
  let titleLabel = UILabel()
  let descriptionLabel = UILabel()
  let separatorView = UIView()

  // MARK: Life cycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    setUpLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    separatorView.isHidden = false
  }

  // MARK: Actions
  private func getHtmlDescription(_ value: String?) -> NSMutableAttributedString? {
    guard let description = value?.data(using: .utf8) else { return nil }

    do {
      let attributedString = try NSMutableAttributedString(
        data: description,
        options: [
          .documentType: NSAttributedString.DocumentType.html,
          .characterEncoding: String.Encoding.utf8.rawValue
        ],
        documentAttributes: nil
      )

      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineSpacing = 3

      attributedString.addAttribute(
        NSAttributedString.Key.paragraphStyle,
        value: paragraphStyle,
        range: NSRange(location: 0, length: attributedString.length)
      )

      attributedString.addAttributes(
        [
          .foregroundColor: YDColors.Gray.light,
          .font: UIFont.systemFont(ofSize: 14)
        ],
        range: NSRange(location: 0, length: attributedString.length)
      )

      return attributedString
    } catch {
      return nil
    }
  }

  // MARK: Public
  func config(with attributes: YDProductAttributes) {
    titleLabel.text = attributes.name
    descriptionLabel.attributedText = getHtmlDescription(attributes.value)
    layoutIfNeeded()
  }
}

// MARK: Layout
extension StoreAndProductTableViewCell {
  func setUpLayout() {
    createSeparatorView()
    createTitleLabel()
    createDescriptionLabel()
  }

  func createSeparatorView() {
    separatorView.backgroundColor = YDColors.Gray.opaque
    contentView.addSubview(separatorView)

    separatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      separatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
      separatorView.heightAnchor.constraint(equalToConstant: 1),
      separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
  }

  func createTitleLabel() {
    titleLabel.font = .systemFont(ofSize: 13)
    titleLabel.textColor = YDColors.branding
    titleLabel.textAlignment = .left
    contentView.addSubview(titleLabel)

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 12),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
  }

  func createDescriptionLabel() {
    descriptionLabel.font = .systemFont(ofSize: 14)
    descriptionLabel.textColor = YDColors.Gray.light
    descriptionLabel.textAlignment = .left
    contentView.addSubview(descriptionLabel)

    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(
        equalTo: titleLabel.bottomAnchor,
        constant: 2.5
      ),
      descriptionLabel.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: 16
      ),
      descriptionLabel.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -16
      ),
      descriptionLabel.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor,
        constant: -18
      )
    ])
  }
}
