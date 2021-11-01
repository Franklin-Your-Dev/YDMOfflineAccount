//
//  YDSegmentedControl.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 15/03/21.
//

import UIKit
import YDExtensions
import YDB2WColors

public protocol YDSegmentedControlDelegate: AnyObject {
  func onChangeYDSegmentControl(_ value: Int, segmented: UISegmentedControl)
}

public class YDSegmentedControl: UIView {
  // MARK: Enum
  private enum Constants {
    static let segmentedControlHeight: CGFloat = 48
    static let underlineViewColor = YDColors.branding
    static let underlineViewHeight: CGFloat = 2
  }

  // MARK: Properties
  private lazy var segmentedControl: UISegmentedControl = {
    let segmentedControl = UISegmentedControl()

    // Remove background and divider colors
    segmentedControl.backgroundColor = .white
    segmentedControl.tintColor = .white

    // Append segments
    segmentedControl.insertSegment(withTitle: "First", at: 0, animated: true)
    segmentedControl.insertSegment(withTitle: "Second", at: 1, animated: true)

    // Select first segment by default
    segmentedControl.selectedSegmentIndex = 0

    // Change text color and the font of the NOT selected (normal) segment
    segmentedControl.setTitleTextAttributes(
      [
        NSAttributedString.Key.foregroundColor: YDColors.Gray.light,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
      ],
      for: .normal
    )
    segmentedControl.setBackgroundImage(
      UIImage(color: .white),
      for: .normal,
      barMetrics: .default
    )

    // Change text color and the font of the selected segment
    segmentedControl.setTitleTextAttributes(
      [
        NSAttributedString.Key.foregroundColor: YDColors.branding,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
      ],
      for: .selected
    )
    segmentedControl.setBackgroundImage(
      UIImage(color: .white),
      for: .selected,
      barMetrics: .default
    )

    // Set dividir color to white
    segmentedControl.setDividerImage(
      UIImage(color: .white),
      forLeftSegmentState: .normal,
      rightSegmentState: .normal,
      barMetrics: .default
    )

    // Set up event handler to get notified when the selected segment changes
    segmentedControl.addTarget(
      self,
      action: #selector(segmentedControlValueChanged),
      for: .valueChanged
    )

    // Return false because we will set the constraints with Auto Layout
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    return segmentedControl
  }()

  // Separator Line
  public lazy var separatorLineView: UIView = {
    let separator = UIView()
    separator.backgroundColor = YDColors.Gray.night
    separator.translatesAutoresizingMaskIntoConstraints = false
    return separator
  }()

  // The underline view below the segmented control
  private lazy var bottomUnderlineView: UIView = {
    let underlineView = UIView()
    underlineView.backgroundColor = Constants.underlineViewColor
    underlineView.translatesAutoresizingMaskIntoConstraints = false
    return underlineView
  }()

  private lazy var leadingDistanceConstraint: NSLayoutConstraint = {
    return bottomUnderlineView.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor)
  }()

  public var delegate: YDSegmentedControlDelegate?

  public var selectedSegmentIndex: Int {
    get {
      return segmentedControl.selectedSegmentIndex
    }
    set {
      DispatchQueue.main.async {
        self.segmentedControl.selectedSegmentIndex = newValue
        self.segmentedControlValueChanged(self.segmentedControl)
      }
    }
  }

  // MARK: Init
  public init() {
    super.init(frame: .zero)

    translatesAutoresizingMaskIntoConstraints = false
    heightAnchor.constraint(equalToConstant: Constants.segmentedControlHeight).isActive = true
    backgroundColor = YDColors.white

    setLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Actions
  @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      self.delegate?.onChangeYDSegmentControl(sender.selectedSegmentIndex, segmented: sender)
      self.changeSegmentedControlLinePosition()
    }
  }

  // Change position of the underline
  private func changeSegmentedControlLinePosition() {
    let segmentIndex = CGFloat(segmentedControl.selectedSegmentIndex)
    let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)
    let leadingDistance = segmentWidth * segmentIndex
    UIView.animate(withDuration: 0.3) { [weak self] in
      guard let self = self else { return }
      self.leadingDistanceConstraint.constant = leadingDistance
      self.layoutIfNeeded()
    }
  }

  // MARK: Public action
  public func setItems(_ items: [String], enabled: [Bool]? = nil) {
    segmentedControl.removeAllSegments()

    for (index, title) in items.enumerated() {
      segmentedControl.insertSegment(withTitle: title, at: index, animated: true)

      if let enable = enabled?.at(index) {
        segmentedControl.setEnabled(enable, forSegmentAt: index)
      }
    }

    segmentedControl.selectedSegmentIndex = 0
  }

  public func setEnabled(_ enabled: Bool, forSegmentAt index: Int) {
    segmentedControl.setEnabled(enabled, forSegmentAt: index)
  }
}

// MARK: Layout
extension YDSegmentedControl {
  func setLayout() {
    addSubview(segmentedControl)
    addSubview(separatorLineView)
    addSubview(bottomUnderlineView)

    // Constrain the segmented control to the container view
    NSLayoutConstraint.activate([
      segmentedControl.topAnchor.constraint(equalTo: topAnchor),
      segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
      segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),
      segmentedControl.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])

    // Separator Line
    NSLayoutConstraint.activate([
      separatorLineView.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
      separatorLineView.heightAnchor.constraint(equalToConstant: 1),
      separatorLineView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor),
      separatorLineView.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor)
    ])

    // Constrain the underline view relative to the segmented control
    NSLayoutConstraint.activate([
      bottomUnderlineView.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
      bottomUnderlineView.heightAnchor.constraint(equalToConstant: Constants.underlineViewHeight),
      leadingDistanceConstraint,
      bottomUnderlineView.widthAnchor.constraint(
        equalTo: segmentedControl.widthAnchor,
        multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)
      )
    ])
  }
}
