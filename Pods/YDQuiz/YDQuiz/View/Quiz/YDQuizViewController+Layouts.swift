//
//  YDQuizViewController+Layouts.swift
//  YDQuiz
//
//  Created by Douglas Hennrich on 02/07/21.
//

import UIKit
import YDExtensions
import YDB2WColors

extension YDQuizViewController {
  func configureLayout() {
    configureLabel()
    configureCollectionView()
  }

  private func configureLabel() {
    view.addSubview(descriptionLabel)
    descriptionLabel.textColor = YDColors.black
    descriptionLabel.numberOfLines = 2
    descriptionLabel.textAlignment = .left
    descriptionLabel.font = .systemFont(ofSize: 16)

    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor),
      descriptionLabel.leadingAnchor
        .constraint(equalTo: view.leadingAnchor, constant: 16),
      descriptionLabel.trailingAnchor
        .constraint(equalTo: view.trailingAnchor, constant: -16)
    ])
  }

  private func configureCollectionView() {
    view.addSubview(collectionView)
    collectionView.backgroundColor = .clear
    collectionView.showsVerticalScrollIndicator = false

    let layout = UICollectionViewFlowLayout()
    layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 30)
    layout.minimumLineSpacing = 8
    layout.scrollDirection = .vertical
    collectionView.collectionViewLayout = layout

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(
        equalTo: descriptionLabel.bottomAnchor,
        constant: 25
      ),
      collectionView.leadingAnchor.constraint(
        equalTo: view.leadingAnchor
      ),
      collectionView.trailingAnchor.constraint(
        equalTo: view.trailingAnchor
      ),
      collectionView.bottomAnchor.constraint(
        equalTo: view.bottomAnchor
      )
    ])

    collectionView.delegate = self
    collectionView.dataSource = self

    collectionView.register(YDQuizChoiceCollectionViewCell.self)
  }
}

// MARK: UICollection DataSource
extension YDQuizViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return quiz?.choices.count ?? 0
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: YDQuizChoiceCollectionViewCell = collectionView
            .dequeueReusableCell(forIndexPath: indexPath)

    guard let choice = quiz?.choices.at(indexPath.row)
    else {
      fatalError()
    }

    cell.configure(with: choice)
    return cell
  }
}

// MARK: UICollection Delegate
extension YDQuizViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let choices = quiz?.choices else { return }

    for(index, item) in choices.enumerated() {
      if index == indexPath.item {
        item.selected = true
        quiz?.storedValue = item.title

      } else {
        item.selected = false
      }
    }

    collectionView.reloadData()
    callback?(quiz)
  }
}
