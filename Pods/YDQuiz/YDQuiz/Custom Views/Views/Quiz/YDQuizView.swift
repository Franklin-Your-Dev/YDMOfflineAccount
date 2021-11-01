//
//  YDQuizView.swift
//  YDQuiz
//
//  Created by Douglas Hennrich on 28/06/21.
//

import UIKit
import YDB2WModels

class YDQuizView: UIView {
  // MARK: Properties
  var quiz: YDB2WModels.YDQuiz?
  var callback: ((_ quiz: YDB2WModels.YDQuiz?) -> Void)?
}
