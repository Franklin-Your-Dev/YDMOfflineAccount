//
//  StoreCardCollectionViewCell.swift
//  YDMFindStore
//
//  Created by Douglas Hennrich on 11/12/20.
//

import UIKit

import YDExtensions
import YDB2WModels
import YDB2WAssets
import YDB2WColors

class YDMFindStoreStoreCardCollectionViewCell: UICollectionViewCell {

  // MARK: Properties
  private var grayColor = UIColor(
    red: 102 / 255,
    green: 102 / 255,
    blue: 102 / 255,
    alpha: 1
  )

  var store: YDStore?
  var callback: ((_ fromProducts: Bool) -> Void)?

  // MARK: IBOutlets
  @IBOutlet weak var container: UIView! {
    didSet {
      container.layer.cornerRadius = 8
      container.layer.applyShadow()
    }
  }

  @IBOutlet weak var logoImageView: UIImageView! {
    didSet {
      logoImageView.tintColor = YDColors.branding
      logoImageView.image = YDAssets.Icons.logo
    }
  }

  @IBOutlet weak var storeLabel: UILabel!

  @IBOutlet weak var addressLabel: UILabel!

  @IBOutlet weak var statusLabel: UILabel!

  @IBOutlet weak var pointImageView: UIImageView! {
    didSet {
      pointImageView.image = YDAssets.Icons.point
    }
  }

  @IBOutlet weak var timeLabel: UILabel!

  @IBOutlet weak var productsButton: UIButton! {
    didSet {
      productsButton.layer.cornerRadius = 4
      productsButton.layer.borderWidth = 1
      productsButton.layer.borderColor = grayColor.cgColor
      productsButton.tintColor = grayColor

      productsButton.setImage(YDAssets.Icons.basket, for: .normal)
      productsButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
    }
  }

  @IBOutlet weak var whatsappButton: UIButton! {
    didSet {
      whatsappButton.layer.cornerRadius = 4
      whatsappButton.layer.borderWidth = 1
      whatsappButton.layer.borderColor = grayColor.cgColor
      whatsappButton.tintColor = grayColor

      whatsappButton.setImage(YDAssets.Icons.whatsapp, for: .normal)
      whatsappButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
    }
  }

  @IBOutlet weak var distanceContainer: UIView! {
    didSet {
      distanceContainer.layer.cornerRadius = 6
    }
  }

  @IBOutlet weak var distanceLabel: UILabel!

  // MARK: Life cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.cornerRadius = 8
    layer.applyShadow()
  }

  // MARK: IBActions
  @IBAction func onProductsAction(_ sender: Any) {
    callback?(true)
  }

  @IBAction func onWhatsappAction(_ sender: Any) {
    callback?(false)
  }

  // MARK: Actions
  public func config(with store: YDStore) {
    self.store = store

    storeLabel.text = store.name
    addressLabel.text = store.formatAddress
    distanceLabel.text = store.formatDistance

    transformTime(with: store.currentOperatingTime, open: store.open ?? false)
  }

  func transformTime(with time: String, open: Bool) {
    let status = open ? "aberto" : "fechada"
    statusLabel.text = status
    statusLabel.textColor = open ? YDColors.Green.done : YDColors.branding

    timeLabel.text = time
  }
}
