//
//  YDErrorView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 14/12/20.
//

import UIKit

import YDB2WAssets
import YDExtensions
import YDB2WColors

public class YDErrorView: UIView {
  // MARK: Properties
  public weak var delegate: YDErrorViewDelegate?
  public var callback: (() -> Void)?

  // MARK: IBOutlets
  @IBOutlet var contentView: UIView!

  @IBOutlet weak var iconImageView: UIImageView! {
    didSet {
      iconImageView.tintColor = YDColors.Gray.night
      iconImageView.image = YDAssets.Icons.sadFace
    }
  }

  @IBOutlet var titleLabel: UILabel! {
    didSet {
      titleLabel.addCharacterSpacing()
    }
  }

  @IBOutlet var descriptionLabel: UILabel! {
    didSet {
      descriptionLabel.addCharacterSpacing()
    }
  }

  @IBOutlet var actionButton: UIButton! {
    didSet {
      actionButton.layer.borderColor = YDColors.branding.cgColor
      actionButton.layer.borderWidth = 1
      actionButton.layer.cornerRadius = 4
    }
  }

  // MARK: Init
  public override init(frame: CGRect) {
    super.init(frame: frame)
    instanceFromNib()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    instanceFromNib()
  }

  private func instanceFromNib() {
    contentView = loadNib()
    addSubview(contentView)

    contentView.translatesAutoresizingMaskIntoConstraints = false

    let top = contentView.topAnchor.constraint(equalTo: self.topAnchor)
    let bottom = contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    let leading = contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
    let trailing = contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)

    NSLayoutConstraint.activate([top, bottom, leading, trailing])
  }

  // MARK: IBActions
  @IBAction func onAction(_ sender: UIButton) {
    delegate?.onActionYDErrorView()
  }
}
