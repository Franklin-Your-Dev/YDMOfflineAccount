//
//  CustomAnnotation.swift
//  YDMFindStore
//
//  Created by Douglas Hennrich on 10/12/20.
//

import UIKit
import MapKit

import YDB2WAssets
import YDExtensions

class CustomLargerAnnotation: MKAnnotationView {
  // MARK: Initialization
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

    frame = CGRect(x: 0, y: 0, width: 40, height: 55)
    centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)

    canShowCallout = true
    setupUI()
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Setup
  private func setupUI() {
    backgroundColor = .clear

    let view = UIView(frame: frame)
    let imageView = UIImageView(image: YDAssets.Images.storePin)
    imageView.frame = frame
    view.addSubview(imageView)

    addSubview(view)
    view.frame = bounds
  }
}
