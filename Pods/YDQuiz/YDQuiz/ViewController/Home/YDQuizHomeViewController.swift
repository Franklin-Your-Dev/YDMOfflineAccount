//
//  YDQuizHomeViewController.swift
//  YDQuiz
//
//  Created by Douglas Hennrich on 27/06/21.
//

import UIKit
import YDB2WComponents
import YDB2WModels
import YDUtilities
import YDExtensions
import YDB2WColors

class YDQuizHomeViewController: UIViewController {
  // MARK: Properties
  lazy var logger = Logger.forClass(Self.self)
  
  var stateView: YDUIStateEnum = .normal {
    didSet {
      changeUIState(with: stateView)
    }
  }
  
  var viewModel: YDQuizHomeViewModelDelegate?
  
  var needToTriggerExitDelegate = true
  
  var onConfirmViewStage = false
  
  var quizzesVC: [YDQuizViewController] = []
  var currentPage = 0

  let socialSecurityCountLimite = 14
  var savedSocialSecurity = ""
  
  var firstShimmer = true
  var commonShimmers: [UIView] = []
  var firstShimmers: [UIView] = []
  var secondShimmers: [UIView] = []

  // MARK: Components
  var navLeftButton: UIBarButtonItem?
  var navRightButton: UIBarButtonItem?

  let descriptionLabel = UILabel()
  let indicatorView = YDQuizIndicatorView()
  let scrollView = UIScrollView()
  lazy var scrollViewTopAnchor: NSLayoutConstraint = {
    scrollView.topAnchor
      .constraint(equalTo: indicatorView.bottomAnchor, constant: 30)
  }()

  let stackView = UIStackView()
  lazy var stackViewHeightConstraint: NSLayoutConstraint = {
    let height = stackView.heightAnchor.constraint(equalToConstant: 100)
    height.isActive = true
    return height
  }()
  lazy var stackViewWidthConstraint: NSLayoutConstraint = {
    let width = stackView.widthAnchor.constraint(equalToConstant: 100)
    width.isActive = true
    return width
  }()

  let buttonsContainer = UIView()
  let backButton = UIButton()
  let nextButton = YDWireButton(withTitle: "avançar")

  let socialSecurityView = YDQuizSocialSecurityView()
  
  let confirmView = YDQuizConfirmView()
  
  let errorView = ErrorView()

  // Shimmers
  let descriptionShimmer = UIView()
  let descriptionShimmer2 = UIView()
  let descriptionShimmer3 = UIView()
  let indicatorViewShimmer = UIView()
  let nextButtonShimmer = UIView()

  let firstShimmerView = UIView()
  let firstShimmerView2 = UIView()
  
  let secondShimmerView = UIView()
  let secondShimmerView2 = UIView()
  let secondShimmerView22 = UIView()
  let secondShimmerView3 = UIView()
  let secondShimmerView32 = UIView()
  let secondShimmerView4 = UIView()
  let secondShimmerView42 = UIView()

  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureLayout()
    configureBinds()
    startSocialSecurityView()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if needToTriggerExitDelegate {
      viewModel?.onExit()
    }
  }
}

// MARK: Actions
extension YDQuizHomeViewController {
  @objc func onExitAction() {
    viewWillDisappear(true)
  }

  @objc func onInfoAction() {
    YDDialog().start(
      ofType: .simple,
      customTitle: "por que preciso responder essas perguntas?",
      customMessage: "Para garantir sua identidade. Ao responder corretamente as perguntas de segurança, você terá acesso ao seu historico de compras nas lojas físicas."
    )
  }

  @objc func onNextAction(_ sender: UIButton) {
    guard checkIfAnsweredAnItsRight() else { return }
    guard checkIfCanProceed() else {
      guard let quiz = viewModel?.quizzes.value.last else { return }
      if quiz.type == .socialSecurity {
        view.endEditing(true)
        guard let socialSecurity = viewModel?.quizzes.value.last?.storedValue
        else { return }
        
        savedSocialSecurity = socialSecurity
        viewModel?.validate(socialSecurity: socialSecurity)
      } else if quiz.type == .confirmView {
        validateQuizzes()
      } else {
        showConfirmView()
      }
      return
    }
    
    currentPage += 1
    scrollTo(page: currentPage)
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      guard let viewModel = self.viewModel else { return }
      
      self.backButton.isEnabled = true
      self.backButton.isHidden = false
      
      let nextButtonEnabled = self.viewModel?[self.currentPage]?.storedValue != nil
      
      self.nextButton.isEnabled = nextButtonEnabled
      self.nextButton.setEnabled(nextButtonEnabled)
      
      let nextButtonTitle = (self.currentPage > (viewModel.quizzes.value.count - 1)) ?
        "finalizar" : "avançar"
      
//          self.logger.info([
//            "(viewModel.quizzes.value.count-1): \(viewModel.quizzes.value.count - 1)",
//            "currentPage: \(self.currentPage)",
//            "nexButtonTitle: \(nextButtonTitle)",
//            "self.viewModel?[self.currentPage]?.storedValue != nil:  \(self.viewModel?[self.currentPage]?.storedValue != nil)",
//            "nextButton.isEnabled: \(self.nextButton.isEnabled)"
//          ])
      
      self.updateNextButtonTitle(with: nextButtonTitle)
    }
  }
  
  func onErrorViewButtonAction(_ sender: UIButton) {
    if onConfirmViewStage {
      validateQuizzes()
    } else {
      viewModel?.validate(socialSecurity: savedSocialSecurity)
    }
  }

  func onQuizCallback(_ quiz: YDB2WModels.YDQuiz?) {
    guard let quiz = quiz,
          let value = quiz.storedValue
    else {
      nextButton.setEnabled(false)
      return
    }

    if value.isEmpty {
      nextButton.setEnabled(false)
      return
    }

    if quiz.type == .socialSecurity {
      if value.count == socialSecurityCountLimite {
        nextButton.setEnabled(true)
        return
      }
      nextButton.setEnabled(false)
      return
    }

//    logger.info(["nextButton set enabled", !value.isEmpty])
    nextButton.setEnabled(!value.isEmpty)
  }
  
  func addViewsToStackView() {
    guard let quizzes = viewModel?.quizzes.value else { return }

    stackView.subviews.forEach { $0.removeFromSuperview() }

    for quiz in quizzes {
      if quiz.type == .socialSecurity {
        socialSecurityView.widthAnchor
          .constraint(equalToConstant: view.frame.size.width).isActive = true
        stackView.addArrangedSubview(socialSecurityView)

      } else if quiz.type == .confirmView {
        confirmView.widthAnchor
          .constraint(equalToConstant: view.frame.size.width).isActive = true
        stackView.addArrangedSubview(confirmView)
        
        //
      } else {
        let vc = YDQuizViewController()
        vc.willMove(toParent: self)
        addChild(vc)

        quizzesVC.append(vc)
        vc.view.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        vc.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        vc.quiz = quiz
        vc.callback = onQuizCallback

        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
      }
    }

    let totalWidth = view.frame.size.width * CGFloat(quizzes.count)

    stackViewWidthConstraint.constant = totalWidth

    if quizzes.count >= 2 {
      stackViewHeightConstraint.constant = 300
      indicatorView.indicators.at(0)?.highlighted = true
    }
    
    if quizzes.first?.type == .confirmView {
      stackViewHeightConstraint.constant = 200
    }

    scrollView.contentSize = CGSize(
      width: totalWidth,
      height: stackViewHeightConstraint.constant
    )
  }
}

// MARK: Private Actions
extension YDQuizHomeViewController {
  private func startSocialSecurityView() {
    let socialQuizModel = YDB2WModels
      .YDQuiz(title: "", choices: [], answer: nil, type: .socialSecurity)
    viewModel?.quizzes.value.append(socialQuizModel)

    socialSecurityView.configure(with: socialQuizModel)
    socialSecurityView.callback = onQuizCallback
    addViewsToStackView()
  }
  
  private func showConfirmView() {
    let confirmQuizModel = YDB2WModels.YDQuiz(
      title: "",
      choices: [],
      answer: nil,
      type: .confirmView
    )
    
    viewModel?.quizzes.value = [confirmQuizModel]
    updateNextButtonTitle(with: "finalizar")
    onConfirmViewStage = true
    indicatorView.isHidden = true
    descriptionLabel.isHidden = true
    scrollViewTopAnchor.constant = -100
    currentPage = 0
    view.layoutIfNeeded()
    
    confirmView.isHidden = false
    confirmView.configure(with: confirmQuizModel)
    confirmView.callback = onQuizCallback
    addViewsToStackView()
  }
  
  private func validateQuizzes() {
    nextButton.setEnabled(false)
    nextButton.widthAnchor
      .constraint(equalToConstant: nextButton.bounds.width).isActive = true
    nextButton.setLoading(true)
    nextButton.activityIndicator.color = YDColors.brandingHighlighted
    needToTriggerExitDelegate = false
    viewModel?.validateQuizzes()
  }
  
  private func checkIfAnsweredAnItsRight() -> Bool {
    guard let quiz = viewModel?[currentPage],
          let value = quiz.storedValue
    else {
      return false
    }

    if value.isEmpty { return false }

    if quiz.type == .socialSecurity {
      if value.count == socialSecurityCountLimite {
        nextButton.setEnabled(false)
        return true
      }

      return false
    }
    
    if quiz.type == .confirmView {
      return true
    }
    
    if value != quiz.answer {
      viewModel?.wrongAnswer()
      return false
    }

    indicatorView.indicators.at(currentPage + 1)?.highlighted = true
    nextButton.setEnabled(false)
    return true
  }

  private func checkIfCanProceed() -> Bool {
    guard let quizzes = viewModel?.quizzes.value else {
      return false
    }
    
    return currentPage < (quizzes.count - 1)
  }
  
  func updateNextButtonTitle(with title: String) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      
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
      
      self.nextButton.setAttributedTitle(attributedString, for: .normal)
      self.nextButton.setAttributedTitle(attributedStringDisabled, for: .disabled)
    }
  }
}

// MARK: Scroll control
extension YDQuizHomeViewController {
  func scrollTo(page: Int) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      let x = CGFloat(page) * self.scrollView.frame.size.width
      self.scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
  }
}
