//
//  HomeViewCell.swift
//  YDMOfflineAccount
//
//  Created by magna on 26/11/21.
//

import UIKit
import YDB2WColors
import YDB2WComponents

class HomeViewCell: UICollectionViewCell {
  
  // MARK: Views
  let card = UIView()
  let imageView = UIImageView()
  let titleLabel = UILabel()
  let newView = YDNewView()
  
  // MARK: Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupCard()
    setupImage()
    setupTitle()
    setupBadgeNew()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    newView.isHidden = true
  }
  
  // MARK: Actions
  func populateView(item: ItensOffinlineAccount) {
    imageView.image = item.icon
    titleLabel.text = item.title
    newView.isHidden = !item.new
  }
  
}

extension HomeViewCell {
  
  func setupCard() {
    self.addSubview(card)
    card.layer.applyShadow(blur: 20)
    card.backgroundColor = .white
    card.layer.cornerRadius = 16
    card.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      card.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
      card.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
      card.heightAnchor.constraint(equalToConstant: 138)
    ])
  }
  
  func setupImage() {
    card.addSubview(imageView)
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalToConstant: 100),
      imageView.heightAnchor.constraint(equalToConstant: 100),
      imageView.centerYAnchor.constraint(equalTo: card.centerYAnchor),
      imageView.leadingAnchor
        .constraint(equalTo: card.leadingAnchor, constant: 26)
    ])
  }
  
  func setupTitle() {
    card.addSubview(titleLabel)
    
    titleLabel.textAlignment = .left
    titleLabel.textColor = YDColors.black
    titleLabel.font = .systemFont(ofSize: 16)
    titleLabel.numberOfLines = 0
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
      titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
      titleLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor)
    ])
  }
  
  func setupBadgeNew() {
    card.addSubview(newView)
    newView.isHidden = true
    newView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      newView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
      newView.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
      newView.heightAnchor.constraint(equalToConstant: 22)
    ])
  }
  
}

