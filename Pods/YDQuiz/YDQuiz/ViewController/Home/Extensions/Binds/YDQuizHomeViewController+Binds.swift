//
//  YDQuizHomeViewController+Binds.swift
//  YDQuiz
//
//  Created by Douglas Hennrich on 30/06/21.
//

import Foundation
import YDB2WComponents
import YDB2WAssets

extension YDQuizHomeViewController {
  func configureBinds() {
    viewModel?.loading.bind { [weak self] isLoading in
      guard let self = self else { return }
      self.stateView = isLoading ? .loading : .normal
    }
    
    viewModel?.loadingQuizzes.bind { [weak self] isLoading in
      guard let self = self else { return }
      self.firstShimmer = false
      self.stateView = isLoading ? .loading : .normal
    }
    
    viewModel?.error.bind { [weak self] message in
      guard let self = self else { return }
      self.stateView = .error
    }

    viewModel?.socialSecurityError.bind { _ in
      // self.socialSecurityView.stateView = .error
      YDDialog().start(
        ofType: .simple,
        customTitle: "poxa, não foi possível confirmar sua identidade",
        customMessage: "Mas, não se preocupe: pra gente te ajudar a entender o que aconteceu, mande um e-mail pra atendimento.acom@americanas.com",
        messageLink: [
          "message": "atendimento.acom@americanas.com",
          "link": "mailto:atendimento.acom@americanas.com"
        ]
      )
    }

    viewModel?.quizzes.bind { [weak self] list in
      guard let self = self else { return }
      self.indicatorView.configure(howMany: 5)
      self.addViewsToStackView()
    }
  }
}
