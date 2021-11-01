//
//  YDShimmerView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 29/01/21.
//

import UIKit
import YDExtensions
import YDB2WColors

public class YDShimmerView: UIView {
  // MARK: Properties
  public var gradientColorOne: CGColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1).cgColor
  public var gradientColorTwo: CGColor = YDColors.Gray.opaque.cgColor
  public var speed: Double = 1

  // MARK: Actions
  func addGradientLayer() -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()

    gradientLayer.frame = self.bounds
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
    gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
    gradientLayer.locations = [0.0, 0.5, 1.0]
    self.layer.addSublayer(gradientLayer)

    return gradientLayer
  }

  func addAnimation(withDelay delay: Double = 0) -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: "locations")
    animation.fromValue = [-1.0, -0.5, 0.0]
    animation.toValue = [1.0, 1.5, 2.0]
    animation.repeatCount = .infinity
    animation.duration = speed
    animation.beginTime = CFTimeInterval() + delay
    return animation
  }

  public func startAnimating(withDelay delay: Double = 0) {
    let gradientLayer = addGradientLayer()
    let animation = addAnimation(withDelay: delay)
    gradientLayer.add(animation, forKey: animation.keyPath)
  }
}
