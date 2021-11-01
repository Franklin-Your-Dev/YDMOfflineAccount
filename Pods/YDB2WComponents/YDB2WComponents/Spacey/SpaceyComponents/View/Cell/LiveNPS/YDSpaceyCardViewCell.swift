//
//  YDSpaceyCardViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 05/07/21.
//

import UIKit
import YDB2WModels
import YDUtilities

public class SpaceyCardViewCell: UICollectionViewCell {
  // MARK: Enum
  private enum CardType {
    case first
    case second
  }

  // MARK: Properties
  let cardPadding: CGFloat = 32

  var cards: [YDSpaceyComponentLiveNPSCard] = []
  var spaceyId: String?

  var firstTimeChecking = true

  var canTouchFirstCard = true
  var canTouchSecondCard = false

  var firstCardId: String?
  var secondCardId: String?

  var sendNPSCallback: ((_ card: YDSpaceyComponentLiveNPSCard?) -> Void)?
  var destroyCallback: (() -> Void)?

  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()

  let firstCardView = YDSpaceyCardView()
  lazy var firstCardWidthConstraint: NSLayoutConstraint = {
    let width = firstCardView.widthAnchor.constraint(equalToConstant: 300)
    width.isActive = true
    return width
  }()
  lazy var firstCardTopConstraint: NSLayoutConstraint = {
    firstCardView.topAnchor.constraint(equalTo: contentView.topAnchor)
  }()
  lazy var firstCardLeadingConstraint: NSLayoutConstraint = {
    firstCardView.leadingAnchor
      .constraint(equalTo: contentView.leadingAnchor, constant: 16)
  }()
  lazy var firstCardCenterXConstraint: NSLayoutConstraint = {
    firstCardView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
  }()

  let secondCardView = YDSpaceyCardView()
  lazy var secondCardWidthConstraint: NSLayoutConstraint = {
    let width = secondCardView.widthAnchor.constraint(equalToConstant: 300)
    width.isActive = true
    return width
  }()
  lazy var secondCardTopConstraint: NSLayoutConstraint = {
    secondCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
  }()
  lazy var secondCardLeadingConstraint: NSLayoutConstraint = {
    secondCardView.leadingAnchor
      .constraint(equalTo: contentView.leadingAnchor, constant: 16)
  }()
  lazy var secondCardCenterXConstraint: NSLayoutConstraint = {
    secondCardView.centerXAnchor
      .constraint(equalTo: contentView.centerXAnchor)
  }()

  let phantomCardView = YDSpaceyCardView()
  lazy var phantomCardWidthConstraint: NSLayoutConstraint = {
    let width = phantomCardView.widthAnchor.constraint(equalToConstant: 300)
    width.isActive = true
    return width
  }()
  lazy var phantomCardTopConstraint: NSLayoutConstraint = {
    phantomCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
  }()
  lazy var phantomCardLeadingConstraint: NSLayoutConstraint = {
    phantomCardView.leadingAnchor
      .constraint(equalTo: contentView.leadingAnchor, constant: 16)
  }()
  lazy var phantomCardCenterXConstraint: NSLayoutConstraint = {
    phantomCardView.centerXAnchor
      .constraint(equalTo: contentView.centerXAnchor)
  }()

  // MARK: Init
  public override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.heightAnchor.constraint(equalToConstant: 202).isActive = true
    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func prepareForReuse() {
    sendNPSCallback = nil
    destroyCallback = nil
    spaceyId = nil
    cards.removeAll()
    firstCardView.cleanUpCard()
    secondCardView.cleanUpCard()
    firstCardView.isHidden = false
    secondCardView.isHidden = false
    phantomCardView.isHidden = false
    firstCardId = nil
    secondCardId = nil
    canTouchFirstCard = true
    canTouchSecondCard = false
    scale(card: firstCardView, direction: .up)
    scale(card: secondCardView, direction: .down)

    firstCardTopConstraint.isActive = true
    firstCardTopConstraint.constant = 0
    firstCardCenterXConstraint.isActive = true
    firstCardLeadingConstraint.isActive = false

    secondCardLeadingConstraint.isActive = false
    secondCardCenterXConstraint.isActive = true
    secondCardTopConstraint.isActive = true
    secondCardTopConstraint.constant = 12

    contentView.layoutIfNeeded()

    contentView.sendSubviewToBack(secondCardView)
    contentView.sendSubviewToBack(phantomCardView)
    super.prepareForReuse()
  }

  public override func systemLayoutSizeFitting(
    _ targetSize: CGSize,
    withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
    verticalFittingPriority: UILayoutPriority
  ) -> CGSize {
    width.constant = bounds.size.width

    firstCardWidthConstraint.constant = bounds.size.width - cardPadding
    secondCardWidthConstraint.constant = bounds.size.width - cardPadding
    phantomCardWidthConstraint.constant = bounds.size.width - cardPadding

    if !secondCardTopConstraint.isActive {
      scale(card: secondCardView, direction: .down)
      scale(card: phantomCardView, direction: .down)

      secondCardTopConstraint.isActive = true
      secondCardLeadingConstraint.isActive = true

      phantomCardTopConstraint.isActive = true
      phantomCardLeadingConstraint.isActive = true
    }

    return contentView.systemLayoutSizeFitting(
      CGSize(width: targetSize.width, height: 1)
    )
  }

  // MARK: Actions
  public func configure(with cards: [YDSpaceyComponentLiveNPSCard], spaceyId: String?) {
    self.cards = cards
    self.spaceyId = spaceyId

    for card in cards {
      if let storedLive = checkIfQuestionAlreadyAnwsered(question: card) {
        card.storedValue = storedLive.answer
      }
    }

    if let firstCard = cards.first(where: { $0.storedValue == nil }) {
      firstCardId = firstCard.id
      firstCardView.configure(with: firstCard)
      firstCardView.callback = questionAnswered
    }

    if let secondCard = cards.first(where: { $0.storedValue == nil && $0.id != firstCardId }) {
      secondCardId = secondCard.id
      secondCardView.configure(with: secondCard)
      secondCardView.callback = questionAnswered

      firstTimeChecking = false
      return
    }

    if firstCardId != nil {
      secondCardView.stateView = .empty
      phantomCardView.isHidden = true

      firstTimeChecking = false
      return
    }

    // No Cards
    if firstTimeChecking {
      firstTimeChecking = false
      destroyCallback?()

    } else {
      firstCardView.stateView = .empty
      secondCardView.isHidden = true
      phantomCardView.isHidden = true
    }
  }

  func questionAnswered(_ card: YDSpaceyComponentLiveNPSCard?, _ cardTag: Int) {
    cards.first(where: { $0.id == card?.id })?.storedValue = card?.storedValue
    sendNPSCallback?(card)
    moveBack(card: cardTag == 0 ? .first : .second)
  }

  func finishLiveNPS() {
    destroyCallback?()
  }
}

// MARK: Private actions
extension SpaceyCardViewCell {
  private func checkIfQuestionAlreadyAnwsered(
    question: YDSpaceyComponentLiveNPSCard
  ) -> YDManagerLiveNPS? {
    guard let id = question.id,
          let spaceyId = spaceyId
    else { return nil }

    return YDManager.LivesNPS.shared.get(id: id, spaceyId: spaceyId)
  }

  @objc func onSkipButtonAction(_ sender: UIButton) {
    if sender.tag == 0 {
      if let card = cards.first(where: { $0.id == firstCardView.card?.id }) {
        cards.first(where: { $0.id == firstCardView.card?.id })?.storedValue = ""
        sendNPSCallback?(card)
      }
    } else {
      if let card = cards.first(where: { $0.id == secondCardView.card?.id }) {
        cards.first(where: { $0.id == secondCardView.card?.id })?.storedValue = ""
        sendNPSCallback?(card)
      }
    }

    moveBack(card: sender.tag == 0 ? .first : .second)
  }

  private func moveBack(card: CardType) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      if card == .first {
        if !self.canTouchFirstCard { return }

        if self.firstCardView.stateView == .empty {
          self.finishLiveNPS()
          return
        }

        self.firstCardCenterXConstraint.isActive = false
        self.firstCardLeadingConstraint.isActive = true
        self.firstCardLeadingConstraint.constant = -self.width.constant + 50

        self.secondCardTopConstraint.constant = 0

        UIView.animate(
          withDuration: 0.5) {
          self.scale(card: self.secondCardView, direction: .up)
          self.contentView.layoutIfNeeded()
        } completion: { _ in
          self.firstCardLeadingConstraint.isActive = false
          self.firstCardCenterXConstraint.isActive = true
          self.firstCardTopConstraint.isActive = true
          self.firstCardTopConstraint.constant = 12

          self.scale(card: self.firstCardView, direction: .down)
          self.contentView.sendSubviewToBack(self.firstCardView)
          self.contentView.sendSubviewToBack(self.phantomCardView)
          self.contentView.layoutIfNeeded()

          self.canTouchFirstCard = false
          self.canTouchSecondCard = true

          if self.cards.first(
            where: { $0.storedValue == nil && $0.id != self.secondCardId }
          ) == nil {
            self.phantomCardView.isHidden = true

            if self.secondCardView.stateView == .empty {
              self.firstCardView.isHidden = true
              return
            }

            self.firstCardView.cleanUpCard()
            self.firstCardView.stateView = .empty

            //
          } else if let nextCard = self.cards.first(
            where: { $0.storedValue != nil && $0.id != self.secondCardId }
          ) {
            self.firstCardId = nextCard.id
            self.firstCardView.cleanUpCard()
            self.firstCardView.configure(with: nextCard)
            self.firstCardView.callback = self.questionAnswered
          }
        }

        //
      } else {
        if !self.canTouchSecondCard { return }

        if self.secondCardView.stateView == .empty {
          self.finishLiveNPS()
          return
        }

        self.secondCardCenterXConstraint.isActive = false
        self.secondCardLeadingConstraint.isActive = true
        self.secondCardLeadingConstraint.constant = -self.width.constant + 50

        self.firstCardTopConstraint.constant = 0

        UIView.animate(
          withDuration: 0.5) {
          self.scale(card: self.firstCardView, direction: .up)
          self.contentView.layoutIfNeeded()
        } completion: { _ in
          self.secondCardLeadingConstraint.isActive = false
          self.secondCardCenterXConstraint.isActive = true
          self.secondCardTopConstraint.isActive = true
          self.secondCardTopConstraint.constant = 12
          self.scale(card: self.secondCardView, direction: .down)

          self.contentView.sendSubviewToBack(self.secondCardView)
          self.contentView.sendSubviewToBack(self.phantomCardView)
          self.contentView.layoutIfNeeded()

          self.canTouchFirstCard = true
          self.canTouchSecondCard = false

          if self.cards.first(
            where: { $0.storedValue == nil && $0.id != self.firstCardId }
          ) == nil {
            self.phantomCardView.isHidden = true
            if self.firstCardView.stateView == .empty {
              self.secondCardView.isHidden = true
              return
            }

            self.secondCardId = nil
            self.secondCardView.cleanUpCard()
            self.secondCardView.stateView = .empty

            //
          } else if let nextCard = self.cards.first(
            where: { $0.storedValue != nil && $0.id != self.firstCardId }
          ) {
            self.secondCardId = nextCard.id
            self.secondCardView.cleanUpCard()
            self.secondCardView.configure(with: nextCard)
            self.secondCardView.callback = self.questionAnswered
          }
        }
      }
    }
  }

  private func scale(card: YDSpaceyCardView, direction: ScaleCardDirection) {
    if direction == .up {
      card.transform = CGAffineTransform(scaleX: 1, y: 1)
    } else {
      card.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
    }
  }
}

// MARK: UI
extension SpaceyCardViewCell {
  func configureLayout() {
    contentView.addSubview(firstCardView)
    firstCardView.skipButton.tag = 0

    firstCardTopConstraint.isActive = true
    firstCardCenterXConstraint.isActive = true
    firstCardView.heightAnchor.constraint(equalToConstant: 190).isActive = true

    firstCardView.skipButton
      .addTarget(self, action: #selector(onSkipButtonAction), for: .touchUpInside)

    // Second
    contentView.addSubview(secondCardView)
    contentView.sendSubviewToBack(secondCardView)

    secondCardView.skipButton.tag = 1
    secondCardView.heightAnchor.constraint(equalToConstant: 190).isActive = true

    secondCardView.skipButton
      .addTarget(self, action: #selector(onSkipButtonAction), for: .touchUpInside)

    // Phantom View
    contentView.addSubview(phantomCardView)
    contentView.sendSubviewToBack(phantomCardView)
    phantomCardView.heightAnchor.constraint(equalToConstant: 190).isActive = true
  }
}

// MARK: Scale Card Direction
fileprivate enum ScaleCardDirection {
  case up
  case down
}
