//
//  HomeViewCell.swift
//  YDMOfflineAccount
//
//  Created by magna on 26/11/21.
//

import UIKit
import YDB2WColors

class HomeViewCell: UICollectionViewCell {
  
  // MARK: Views
  let card = UIView()
  let imageView = UIImageView()
  let titleLabel = UILabel()
  let newContainer = UIView()
  let newLabel = UILabel()
 
  // MARK: Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
    setupCard()
    setupImage()
    setupTitle()
    setupNewLabel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Actions
  func populateView(item: ItensOffinlineAccount) {
    imageView.image = item.icon
    titleLabel.text = item.title
    newContainer.isHidden = !item.new
  }
  
}

extension HomeViewCell {
  
  func initView() { }
  
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
    
    titleLabel.textAlignment = .center
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
  
  func setupNewContainer() {
    card.addSubview(newContainer)
    
    newContainer.backgroundColor = YDColors.branding
    newContainer.layer.masksToBounds = true
    newContainer.layer.cornerRadius = 10
    
    newContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      newContainer.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
      newContainer.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
      newContainer.heightAnchor.constraint(equalToConstant: 22)
    ])
  }
  
  func setupNewLabel() {
    newContainer.addSubview(newLabel)
    newLabel.textColor = .white
    newLabel.textAlignment = .center
    newLabel.font = UIFont.systemFont(ofSize: 14)
    newLabel.text = "novo"
    
    newLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      newLabel.centerYAnchor.constraint(equalTo: newContainer.centerYAnchor),
      newLabel.leadingAnchor.constraint(equalTo: newContainer.leadingAnchor, constant: 12),
      newLabel.trailingAnchor.constraint(equalTo: newContainer.trailingAnchor, constant: -12)
    ])
    
  }
  
}
