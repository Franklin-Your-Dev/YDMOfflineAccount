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

    viewModel?.socialSecurityError.bind { [weak self] _ in
      guard let self = self else { return }
      self.socialSecurityView.stateView = .error
    }

    viewModel?.quizzes.bind { [weak self] list in
      guard let self = self else { return }
      self.indicatorView.configure(howMany: 5)
      self.addViewsToStackView()
    }
  }
}
