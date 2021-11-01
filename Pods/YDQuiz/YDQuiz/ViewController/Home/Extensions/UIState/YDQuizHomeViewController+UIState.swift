//
//  YDQuizHomeViewController+UIState.swift
//  YDQuiz
//
//  Created by Douglas Hennrich on 01/07/21.
//

import UIKit
import YDUtilities

extension YDQuizHomeViewController: YDUIStateDelegate {
  public func changeUIState(with type: YDUIStateEnum) {
    switch type {
      case .normal:
        changeUIStateToNormal()
        
      case .loading:
        changeUIStateToLoading()
        
      case .error:
        changeUIStateToError()
        
      default: break
    }
  }
}

// MARK: Actions
extension YDQuizHomeViewController {
  private func actionOnShimmers(hide: Bool) {
    if hide {
      self.commonShimmers.forEach {
        $0.isHidden = true
        $0.stopShimmer()
      }

      self.firstShimmers.forEach {
        $0.isHidden = true
        $0.stopShimmer()
      }

      self.secondShimmers.forEach {
        $0.isHidden = true
        $0.stopShimmer()
      }
      
      //
    } else {
      self.commonShimmers.forEach {
        $0.isHidden = false
        $0.startShimmer()
      }
      
      if self.firstShimmer {
        self.secondShimmers.forEach {
          $0.isHidden = true
          $0.stopShimmer()
        }

        self.firstShimmers.forEach {
          $0.isHidden = false
          $0.startShimmer()
        }

      } else {
        self.firstShimmers.forEach {
          $0.isHidden = true
          $0.stopShimmer()
        }

        self.secondShimmers.forEach {
          $0.isHidden = false
          $0.startShimmer()
        }
      }
    }
  }
  
  private func changeUIStateToNormal() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      if self.onConfirmViewStage {
        self.updateNextButtonTitle(with: "finalizar")
        self.indicatorView.isHidden = true
        self.descriptionLabel.isHidden = true
        self.confirmView.isHidden = false
        
      } else {
        self.descriptionLabel.isHidden = false
        self.scrollView.isHidden = false
        self.indicatorView.isHidden = false
      }
      
      self.buttonsContainer.isHidden = false

      self.actionOnShimmers(hide: true)
    }
  }
  
  private func changeUIStateToLoading() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      
      self.errorView.isHidden = true
      self.descriptionLabel.isHidden = true
      self.scrollView.isHidden = true
      self.confirmView.isHidden = true
      self.buttonsContainer.isHidden = true

      self.actionOnShimmers(hide: false)
    }
  }
  
  private func changeUIStateToError() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.needToTriggerExitDelegate = true
      
      self.errorView.isHidden = false
      
      self.descriptionLabel.isHidden = true
      self.scrollView.isHidden = true
      self.confirmView.isHidden = true
      self.buttonsContainer.isHidden = true
      self.indicatorView.isHidden = true
      
      if self.onConfirmViewStage {
        self.nextButton.setLoading(false)
      }
      
      self.actionOnShimmers(hide: true)
    }
  }
}
