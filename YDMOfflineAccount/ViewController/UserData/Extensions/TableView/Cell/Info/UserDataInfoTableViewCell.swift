//
//  UserDataTableViewCell.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 25/01/21.
//

import UIKit
import YDB2WModels

class UserDataInfoTableViewCell: UITableViewCell {
  // MARK: IBOutlets
  @IBOutlet weak var titleLabel: UILabel!

  @IBOutlet weak var valueLabel: UILabel!

  @IBOutlet weak var optionalTitleLabel: UILabel!

  @IBOutlet weak var optionalValueLabel: UILabel!

  // MARK: Life cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.text = nil
    valueLabel.text = nil

    optionalTitleLabel.isHidden = true
    optionalTitleLabel.text = nil

    optionalValueLabel.isHidden = true
    optionalValueLabel.text = nil
  }

  // MARK: Config
  func config(with data: YDLasaClientDataSet) {
    titleLabel.text = data.title
    valueLabel.text = data.value

//    if data.title == "nome" {
//      valueLabel.numberOfLines = 0
//    }

    if let secondTitle = data.doubleTitle,
       let secondValue = data.doubleValue {
      optionalTitleLabel.isHidden = false
      optionalTitleLabel.text = secondTitle

      optionalValueLabel.isHidden = false
      optionalValueLabel.text = secondValue
    }
  }
}
