//
//  UserDataMarketingTableViewCell.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 26/01/21.
//

import UIKit

class UserDataMarketingTableViewCell: UITableViewCell {
  // MARK: Properties
  var callback: ((Bool) -> Void)?

  // MARK: IBOutlets
  @IBOutlet weak var marketingLabel: UILabel!

  @IBOutlet weak var marketingSwitch: UISwitch!

  @IBOutlet weak var switchLabel: UILabel!

  // MARK: Life cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    marketingSwitch.setOn(false, animated: false)
  }

  // MARK: Config
  func config(withValue switchValue: Bool, onAction action: @escaping ((Bool) -> Void)) {
    marketingSwitch.setOn(switchValue, animated: true)
    callback = action
  }

  // MARK: IBActions
  @IBAction func onSwitchChange(_ sender: Any) {
    callback?(marketingSwitch.isOn)
  }
}
