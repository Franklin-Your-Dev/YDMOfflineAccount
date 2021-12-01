//
//  HistoricViewController+Layout.swift
//  YDMstoreModeOfflineAccount
//
//  Created by Douglas Hennrich on 23/02/21.
//

import UIKit

import YDExtensions
import YDB2WModels
import YDB2WColors

extension HistoricViewController {
  func buildList() {
    guard let list = viewModel?.historicList.value else { return }

    for (index, curr) in list.enumerated() {
      let vw = UIStackView()
      vw.axis = .vertical
      vw.alignment = .center
      vw.distribution = .fill
      vw.spacing = 0
      stackView.addArrangedSubview(vw)

      vw.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        vw.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
        vw.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16)
      ])

      if index == 0 {
        let spaceView = UIView()
        spaceView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        vw.addArrangedSubview(spaceView)
      }

      // Date
      if curr.formattedDate != nil {
        buildDateContainer(parent: vw, withData: curr)
      }

      // Origin
      buildOriginContainer(parent: vw, withData: curr)

      // Datas
      buildDatasContainer(parent: vw, withData: curr)

      // Objective
      buildObjectiveContainer(parent: vw, withData: curr)

      // Separator
      if index != list.count - 1 {
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        vw.addArrangedSubview(separatorView)

        NSLayoutConstraint.activate([
          separatorView.heightAnchor.constraint(equalToConstant: 1),
          separatorView.leadingAnchor.constraint(equalTo: vw.leadingAnchor),
          separatorView.trailingAnchor.constraint(equalTo: vw.trailingAnchor)
        ])

        //
      } else {
        let spaceView = UIView()
        spaceView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        vw.addArrangedSubview(spaceView)
      }
    }
  }

  func buildDateContainer(
    parent vw: UIStackView,
    withData data: YDLasaClientHistoricData
  ) {
    let dateContainer = UIView()
    dateContainer.layer.cornerRadius = 12
    dateContainer.layer.applyShadow()
    dateContainer.backgroundColor = .white
    vw.addArrangedSubview(dateContainer)
    vw.setCustomSpacing(25, after: dateContainer)

    dateContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateContainer.centerXAnchor.constraint(equalTo: vw.centerXAnchor),
      dateContainer.heightAnchor.constraint(equalToConstant: 24)
    ])

    let dateLabel = UILabel()
    dateLabel.text = data.formattedDate
    dateLabel.font = .systemFont(ofSize: 14)
    dateLabel.textColor = YDColors.black
    dateLabel.textAlignment = .center
    dateContainer.addSubview(dateLabel)

    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.leadingAnchor.constraint(equalTo: dateContainer.leadingAnchor, constant: 43),
      dateLabel.trailingAnchor.constraint(equalTo: dateContainer.trailingAnchor, constant: -43),
      dateLabel.centerYAnchor.constraint(equalTo: dateContainer.centerYAnchor)
    ])
  }

  func buildOriginContainer(
    parent vw: UIStackView,
    withData data: YDLasaClientHistoricData
  ) {
    let originLabelDescription = UILabel()
    originLabelDescription.textColor = YDColors.Gray.light
    originLabelDescription.font = .systemFont(ofSize: 14)
    originLabelDescription.textAlignment = .left
    originLabelDescription.text = "origem"
    vw.addArrangedSubview(originLabelDescription)
    vw.setCustomSpacing(4, after: originLabelDescription)

    NSLayoutConstraint.activate([
      originLabelDescription.leadingAnchor.constraint(equalTo: vw.leadingAnchor),
      originLabelDescription.heightAnchor.constraint(equalToConstant: 24),
    ])

    let originLabel = UILabel()
    originLabel.textColor = YDColors.black
    originLabel.font = .systemFont(ofSize: 16)
    originLabel.textAlignment = .left
    originLabel.text = data.origin
    originLabel.numberOfLines = 2
    vw.addArrangedSubview(originLabel)
    vw.setCustomSpacing(20, after: originLabel)

    NSLayoutConstraint.activate([
      originLabel.leadingAnchor.constraint(equalTo: vw.leadingAnchor),
      originLabel.trailingAnchor.constraint(equalTo: vw.trailingAnchor)
    ])
  }

  func buildDatasContainer(
    parent vw: UIStackView,
    withData data: YDLasaClientHistoricData
  ) {
    let datasLabelDescription = UILabel()
    datasLabelDescription.textColor = YDColors.Gray.light
    datasLabelDescription.font = .systemFont(ofSize: 14)
    datasLabelDescription.textAlignment = .left
    datasLabelDescription.text = "dados informados"
    vw.addArrangedSubview(datasLabelDescription)
    vw.setCustomSpacing(4, after: datasLabelDescription)

    NSLayoutConstraint.activate([
      datasLabelDescription.leadingAnchor.constraint(equalTo: vw.leadingAnchor),
      datasLabelDescription.heightAnchor.constraint(equalToConstant: 24),
    ])

    let infos = data.getHistoricDataSet()

    for (index, curr) in infos.enumerated() {
      let view = UIView()
      vw.addArrangedSubview(view)

      if index == 0 {
        vw.setCustomSpacing(0, after: view)
      }

      view.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        view.leadingAnchor.constraint(equalTo: vw.leadingAnchor),
        view.trailingAnchor.constraint(equalTo: vw.trailingAnchor),
        view.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
      ])

      let messageLabel = UILabel()
      messageLabel.textAlignment = .left
      messageLabel.numberOfLines = 2
      messageLabel.attributedText = createAttributedString(
        title: curr.title,
        value: curr.value
      )
      view.addSubview(messageLabel)

      messageLabel.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        messageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 2),
        messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        messageLabel.bottomAnchor
          .constraint(equalTo: view.bottomAnchor, constant: -2),
        messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
      ])

      if index == infos.count - 1 {
        vw.setCustomSpacing(20, after: view)
      }
    }
  }

  func buildObjectiveContainer(
    parent vw: UIStackView,
    withData data: YDLasaClientHistoricData
  ) {
    let objectiveLabelDescription = UILabel()
    objectiveLabelDescription.textColor = YDColors.Gray.light
    objectiveLabelDescription.font = .systemFont(ofSize: 14)
    objectiveLabelDescription.textAlignment = .left
    objectiveLabelDescription.text = "objetivo"
    vw.addArrangedSubview(objectiveLabelDescription)
    vw.setCustomSpacing(4, after: objectiveLabelDescription)

    NSLayoutConstraint.activate([
      objectiveLabelDescription.leadingAnchor.constraint(equalTo: vw.leadingAnchor),
      objectiveLabelDescription.heightAnchor.constraint(equalToConstant: 24),
    ])

    let objectiveLabel = UILabel()
    objectiveLabel.textColor = YDColors.black
    objectiveLabel.font = .systemFont(ofSize: 16)
    objectiveLabel.textAlignment = .left
    objectiveLabel.text = data.objective
    objectiveLabel.numberOfLines = 2
    vw.addArrangedSubview(objectiveLabel)
    vw.setCustomSpacing(20, after: objectiveLabel)

    NSLayoutConstraint.activate([
      objectiveLabel.leadingAnchor.constraint(equalTo: vw.leadingAnchor),
      objectiveLabel.trailingAnchor.constraint(equalTo: vw.trailingAnchor)
    ])
  }
}

extension HistoricViewController {
  func createAttributedString(
    title: String,
    value: String
  ) -> NSMutableAttributedString? {
    let fullMessage = "\(title):  \(value)"

    let attributedString = NSMutableAttributedString(
      string: fullMessage,
      attributes: [
        NSAttributedString.Key.foregroundColor: YDColors.black
      ]
    )

    // Title
    guard let rangeTitle: Range<String.Index> = fullMessage.range(of: title) else {
      return nil
    }

    let indexTitle: Int = fullMessage.distance(
      from: fullMessage.startIndex,
      to: rangeTitle.lowerBound
    )

    attributedString.addAttribute(
      NSAttributedString.Key.font,
      value: UIFont.systemFont(ofSize: 16, weight: .bold),
      range: NSRange(location: indexTitle, length: title.count)
    )

    // Value
    guard let rangeValue: Range<String.Index> = fullMessage.range(of: value)
    else {
      return nil
    }

    let indexValue: Int = fullMessage.distance(
      from: fullMessage.startIndex,
      to: rangeValue.lowerBound
    )

    attributedString.addAttribute(
      NSAttributedString.Key.font,
      value: UIFont.systemFont(ofSize: 16),
      range: NSRange(location: indexValue, length: value.count)
    )

    return attributedString
  }
}
