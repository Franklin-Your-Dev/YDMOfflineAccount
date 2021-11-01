//
//  UserDataTermsAndButtonTableViewCell.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 27/01/21.
//

import UIKit

import YDExtensions
import YDB2WColors

class UserDataTermsAndButtonTableViewCell: UITableViewCell {
  // MARK: Properties
  var onTermsCallback: (() -> Void)?
  var onSaveCallback: ((Bool) -> Void)?

  // MARK: IBOutlets
  @IBOutlet weak var termsSwitch: UISwitch!

  @IBOutlet weak var termsButton: UIButton!

  @IBOutlet weak var saveButton: UIButton! {
    didSet {
      saveButton.layer.borderWidth = 1
      saveButton.layer.borderColor = YDColors.branding.cgColor
      saveButton.layer.cornerRadius = 6
    }
  }

  // MARK: Life cycle
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    termsSwitch.setOn(false, animated: false)
    onSaveCallback = nil
    onTermsCallback = nil
  }

  // MARK: Config
  func config(
    withValue switchValue: Bool,
    onTerms: @escaping (() -> Void),
    onSave: @escaping ((Bool) -> Void)
  ) {
    buildAttributedString()
    termsSwitch.setOn(switchValue, animated: true)

    onTermsCallback = onTerms
    onSaveCallback = onSave
  }

  func buildAttributedString() {
    let termsText = "Li e concordo com os Termos e condições e Política de privacidade."
    let toUnderline = "Termos e condições e Política de privacidade."

    let attributedString = NSMutableAttributedString(string: termsText)

    guard let range = termsText.range(of: toUnderline) else {
      return
    }

    let index = termsText.distance(from: termsText.startIndex, to: range.lowerBound)
    let location = NSRange(location: index, length: toUnderline.count)

    attributedString.addAttribute(
      NSAttributedString.Key.underlineStyle,
      value: NSUnderlineStyle.single.rawValue,
      range: location
    )

    attributedString.addAttribute(
      NSAttributedString.Key.foregroundColor,
      value: YDColors.branding,
      range: location
    )

    termsButton.setAttributedTitle(attributedString, for: .normal)
    layoutIfNeeded()
  }

  // MARK: IBActions
  @IBAction func onButtonAction(_ sender: Any) {
    onSaveCallback?(termsSwitch.isOn)
  }

  @IBAction func onTermsAction(_ sender: Any) {
    onTermsCallback?()
  }
}
