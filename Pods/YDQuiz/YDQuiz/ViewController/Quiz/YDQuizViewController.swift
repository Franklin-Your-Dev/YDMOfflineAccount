//
//  YDQuizViewController.swift
//  YDQuiz
//
//  Created by Douglas Hennrich on 02/07/21.
//

import UIKit
import YDB2WModels

class YDQuizViewController: UIViewController {
  // MARK: Properties
  var quiz: YDB2WModels.YDQuiz? {
    didSet {
      descriptionLabel.text = quiz?.title
      collectionView.reloadData()
    }
  }
  var callback: ((_ quiz: YDB2WModels.YDQuiz?) -> Void)?

  // MARK: Components
  let descriptionLabel = UILabel()
  let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()
  )

  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureLayout()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    // collectionView.contentSize.height
  }
}
