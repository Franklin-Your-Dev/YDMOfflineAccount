//
//  YDAnimationBlock.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 17/11/20.
//

import UIKit
import YDExtensions
import YDB2WColors

public class YDAnimationBlock: UIView {
  // MARK: Properties
  var icons: [UIImage?] = []
  let sizes: [CGFloat] = [24, 20, 18]
  var columns: [CGFloat] = [-10, 5, 20, 30, 35, 40]
  public var iconTintColor: UIColor? = YDColors.branding

  // MARK: Init
  public init() {
    let rect = CGRect(x: 0, y: 0, width: 60, height: 420)
    super.init(frame: rect)
    backgroundColor = .clear
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    backgroundColor = .clear
  }

  public func config(iconsToSort: [UIImage?]) {
    self.icons = iconsToSort
  }

  public func addIcon(fromMyself: Bool = false, myselfIcon: UIImage? = nil) {
    if fromMyself {
      let size: CGFloat = 24
      let x: CGFloat = 15
      let iconImage = myselfIcon
      let futureX = columns.randomElement() ?? 0

      let icon = UIImageView(image: iconImage)
      icon.frame = CGRect(x: x, y: frame.height, width: size, height: size)
      icon.tintColor = iconTintColor
      addSubview(icon)

      UIView.animate(withDuration: 2) {
        icon.frame = CGRect(
          x: futureX,
          y: -50,
          width: icon.frame.width,
          height: icon.frame.height
        )
        icon.alpha = 0
      } completion: { _ in
        icon.removeFromSuperview()
      }
      return
    }

    for _ in 1...2 {
      let size = sizes.randomElement() ?? 0
      let x = columns.randomElement() ?? 0
      let futureX = columns.randomElement() ?? 0
      let iconImage = icons.randomElement() ?? nil
      let randomY = [frame.height, frame.height-5, frame.height-10, frame.height-15].randomElement() ?? frame.height

      let icon = UIImageView(image: iconImage)
      icon.frame = CGRect(x: x, y: randomY, width: size, height: size)
      icon.tintColor = iconTintColor
      addSubview(icon)

      UIView.animate(withDuration: 2) {
        icon.frame = CGRect(
          x: futureX,
          y: -50,
          width: icon.frame.width,
          height: icon.frame.height
        )
        icon.alpha = 0
      } completion: { _ in
        icon.removeFromSuperview()
      }
    }
  }
}
