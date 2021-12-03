//
//  YDCountDownView.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 09/06/21.
//

import UIKit
import YDExtensions
import YDB2WModels
import YDB2WAssets
import YDB2WColors

public class YDCountDownView: UIView {
  // MARK: Properties
  public var updateTimer: Timer?

  // MARK: Components
  let titleLabel = UILabel()
  let vStackView = UIStackView()
  let stackView = UIStackView()
  
  let daysView = YDCountDownComponentView(description: "dias")
  let hoursView = YDCountDownComponentView(description: "horas")
  let minutesView = YDCountDownComponentView(description: "minutos")
  let secondsView = YDCountDownComponentView(description: "segundos")
  
  let finishedView = UIView()
  let finishedTitle = UILabel()
  let finishedDescription = UILabel()
  let finishedIcon = UIImageView()

  // MARK: Init
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public init() {
    super.init(frame: .zero)
    configureUI()
  }

  // MARK: Actions
  public func start(with date: Date) {
    updateTimer?.invalidate()

    updateTimer = Timer.scheduledTimer(
      withTimeInterval: 1,
      repeats: true
    ) { [weak self] _ in
      guard let selfStrong = self else {
        self?.updateTimer?.invalidate()
        return
      }

      selfStrong.updateCountDown(with: date)
    }
  }

  public func stopTimer() {
    updateTimer?.invalidate()
    daysView.resetComponent()
    hoursView.resetComponent()
    minutesView.resetComponent()
    secondsView.resetComponent()
  }

  @objc func updateCountDown(with date: Date) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      let now = Date()

      if date < now {
        self.stopTimer()
        self.finishedView.isHidden = false
        return
      }

      let diff = Calendar.current.dateComponents(
        [.day, .hour, .minute, .second],
        from: now,
        to: date
      )

      if diff.second != nil {
        let (first, last) = self.getFirstAndLast(from: diff.second ?? 0)
        self.secondsView.update(left: first, right: last)
      }

      if diff.minute != nil {
        let (first, last) = self.getFirstAndLast(from: diff.minute ?? 0)
        self.minutesView.update(left: first, right: last)
      }

      if diff.hour != nil {
        let (first, last) = self.getFirstAndLast(from: diff.hour ?? 0)
        self.hoursView.update(left: first, right: last)
      }

      if diff.day != nil {
        let (first, last) = self.getFirstAndLast(from: diff.day ?? 0)
        self.daysView.update(left: first, right: last)
      }
    }
  }

  private func getFirstAndLast(from number: Int) -> (first: String?, last: String?) {
    if number >= 10,
       let firstNumber = "\(number)".first,
       let lastNumber = "\(number)".last {
      return (String(firstNumber), String(lastNumber))
    } else {
      return ("0", "\(number)")
    }
  }
}

// MARK: UI
extension YDCountDownView {
  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .white
    layer.cornerRadius = 6

    configureTitleLabel()
    configureStackView()
    
    configureFinishedView()
    configureFinishedIcon()
    configureFinishedTitle()
    configureFinishedDescription()
  }

  private func configureTitleLabel() {
    addSubview(titleLabel)
    titleLabel.textColor = YDColors.black
    titleLabel.font = .boldSystemFont(ofSize: 14)
    titleLabel.textAlignment = .center
    titleLabel.text = "ei, a próxima live começa em:"

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      titleLabel.heightAnchor.constraint(equalToConstant: 18)
    ])
  }

  private func configureStackView() {
    addSubview(vStackView)
    vStackView.alignment = .center
    vStackView.axis = .vertical

    vStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      vStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
      vStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      vStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      vStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
    ])

    vStackView.addArrangedSubview(stackView)
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.spacing = 5
    stackView.distribution = .fillProportionally

    //
    let firstDots = createSeparatorDots()
    let views = [
      daysView,
      firstDots,
      hoursView,
      createSeparatorDots(),
      minutesView,
      createSeparatorDots(),
      secondsView
    ]

    views.forEach { stackView.addArrangedSubview($0) }
  }

  private func createSeparatorDots() -> UIView {
    let container = UIView()
    let dots = UILabel()
    container.addSubview(dots)
    dots.textColor = YDColors.Gray.light
    dots.font = .boldSystemFont(ofSize: 20)
    dots.text = ":"

    dots.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dots.topAnchor.constraint(equalTo: container.topAnchor, constant: -10),
      dots.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 2),
      dots.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -2),
      dots.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
    ])

    return container
  }
  
  private func configureFinishedView() {
    addSubview(finishedView)
    finishedView.isHidden = true
    finishedView.backgroundColor = .white
    finishedView.layer.cornerRadius = 6
    
    finishedView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      finishedView.topAnchor.constraint(equalTo: topAnchor),
      finishedView.leadingAnchor.constraint(equalTo: leadingAnchor),
      finishedView.trailingAnchor.constraint(equalTo: trailingAnchor),
      finishedView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  private func configureFinishedIcon() {
    finishedView.addSubview(finishedIcon)
    finishedIcon.image = YDAssets.Icons.happyFace
    finishedIcon.tintColor = YDColors.Red.night
    
    finishedIcon.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      finishedIcon.trailingAnchor.constraint(
        equalTo: finishedView.trailingAnchor,
        constant: -24
      ),
      finishedIcon.widthAnchor.constraint(equalToConstant: 81),
      finishedIcon.heightAnchor.constraint(equalToConstant: 81),
      finishedIcon.centerYAnchor.constraint(equalTo: finishedView.centerYAnchor)
    ])
  }
  
  private func configureFinishedTitle() {
    finishedView.addSubview(finishedTitle)
    finishedTitle.font = .boldSystemFont(ofSize: 24)
    finishedTitle.textColor = YDColors.black
    finishedTitle.textAlignment = .left
    finishedTitle.numberOfLines = 0
    finishedTitle.text = """
    eeei, fica
    com a gente!
    """
    
    finishedTitle.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      finishedTitle.topAnchor.constraint(equalTo: finishedView.topAnchor, constant: 24),
      finishedTitle.leadingAnchor.constraint(
        equalTo: finishedView.leadingAnchor,
        constant: 20
      ),
      finishedTitle.trailingAnchor.constraint(
        equalTo: finishedIcon.leadingAnchor,
        constant: -34
      )
    ])
  }
  
  private func configureFinishedDescription() {
    finishedView.addSubview(finishedDescription)
    finishedDescription.font = .systemFont(ofSize: 14, weight: .medium)
    finishedDescription.textColor = YDColors.Gray.light
    finishedDescription.textAlignment = .left
    finishedDescription.text = "a live vai começar já já"
    
    finishedDescription.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      finishedDescription.leadingAnchor.constraint(equalTo: finishedTitle.leadingAnchor),
      finishedDescription.trailingAnchor.constraint(equalTo: finishedTitle.trailingAnchor),
      finishedDescription.bottomAnchor.constraint(
        equalTo: finishedView.bottomAnchor,
        constant: -24
      )
    ])
  }
}
