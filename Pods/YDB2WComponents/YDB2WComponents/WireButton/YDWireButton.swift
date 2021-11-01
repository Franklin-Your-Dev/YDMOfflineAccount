//
//  YDWireButton.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 24/11/20.
//

import UIKit
import YDExtensions
import YDB2WColors

public class YDWireButton: UIButton {
  // MARK: Properties
  public var callback: ((_ sender: UIButton) -> Void)?
  private var title = ""
  private var previousTitle = ""
  
  override open var isHighlighted: Bool {
    didSet {
      layer.borderColor = isHighlighted ?
        YDColors.brandingHighlighted.cgColor :
        YDColors.branding.cgColor
    }
  }
  
  // MARK: Components
  public lazy var activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.hidesWhenStopped = true
    activityIndicator.color = YDColors.branding
    return activityIndicator
  }()
  
  public lazy var buttonHeightConstraint: NSLayoutConstraint = {
    heightAnchor.constraint(equalToConstant: 40)
  }()

  // MARK: Init
  public init() {
    super.init(frame: .zero)
    self.title = ""
    setUpStyle()
  }

  public init(withTitle title: String) {
    super.init(frame: .zero)
    self.title = title

    setUpStyle()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.title = self.titleLabel?.text ?? ""

    DispatchQueue.main.async {
      self.setUpStyle()
    }
  }

  // MARK: Actions
  public func setUpStyle() {
    translatesAutoresizingMaskIntoConstraints = false
    buttonHeightConstraint.isActive = true
    layer.cornerRadius = 8
    layer.borderWidth = 1.5
    layer.borderColor = YDColors.branding.cgColor

    let attributedString = NSAttributedString(
      string: self.title,
      attributes: [
        NSAttributedString.Key.foregroundColor: YDColors.branding,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
      ]
    )

    let attributedStringDisabled = NSAttributedString(
      string: self.title,
      attributes: [
        NSAttributedString.Key.foregroundColor: YDColors.brandingHighlighted,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
      ]
    )

    setAttributedTitle(attributedString, for: .normal)
    setAttributedTitle(attributedStringDisabled, for: .disabled)
    setAttributedTitle(attributedStringDisabled, for: .highlighted)
    
    titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

    addTarget(self, action: #selector(onButtonAction), for: .touchUpInside)
  }

  public override func setTitle(
    _ title: String?,
    for state: UIControl.State
  ) {
    guard let title = title else { return }
    self.title = title

    let attributedString = NSAttributedString(
      string: title,
      attributes: [
        NSAttributedString.Key.foregroundColor: YDColors.branding,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
      ]
    )

    let attributedStringDisabled = NSAttributedString(
      string: title,
      attributes: [
        NSAttributedString.Key.foregroundColor: YDColors.brandingHighlighted,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
      ]
    )

    DispatchQueue.main.async {
      self.setAttributedTitle(attributedString, for: state)
      self.setAttributedTitle(attributedStringDisabled, for: .disabled)
    }
  }
  
  public func setTitle(
    _ title: String?,
    for state: UIControl.State,
    withColor color: UIColor = YDColors.branding
  ) {
    guard let title = title else { return }
    self.title = title

    let attributedString = NSAttributedString(
      string: title,
      attributes: [
        NSAttributedString.Key.foregroundColor: color,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
      ]
    )
    
    DispatchQueue.main.async {
      self.setAttributedTitle(attributedString, for: state)
    }
  }
  
  public func setEnabled(_ enabled: Bool) {
    DispatchQueue.main.async {
      self.isEnabled = enabled

      if enabled {
        self.layer.borderColor = YDColors.branding.cgColor
      } else {
        self.layer.borderColor = YDColors.brandingHighlighted.cgColor
      }
    }
  }

  @objc func onButtonAction(_ sender: UIButton) {
    callback?(sender)
  }
  
  public func setLoading(_ actived: Bool) {
    if actived {
      previousTitle = self.title
      setTitle("", for: .normal)
      
      addSubview(activityIndicator)
      activityIndicator.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
      ])
      
      activityIndicator.startAnimating()
      return
    }
    
    activityIndicator.stopAnimating()
    activityIndicator.removeFromSuperview()
    setTitle(previousTitle, for: .normal)
  }
}
