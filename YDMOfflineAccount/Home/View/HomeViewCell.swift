//
//  HomeViewCell.swift
//  YDMOfflineAccount
//
//  Created by magna on 26/11/21.
//

import UIKit
import YDB2WColors

class HomeViewCell: UICollectionViewCell {
  
  // MARK: Properties
  let card: UIView = {
    let card = UIView()
    card.layer.applyShadow(blur: 20)
    card.backgroundColor = .white
    card.layer.cornerRadius = 16
    return card
  }()

  let imageView = UIImageView()
 
  let titleLabel: UILabel = {
    let view = UILabel()
    view.textAlignment = .center
    view.textColor = YDColors.black
    view.font = .systemFont(ofSize: 16)
    view.numberOfLines = 0
    return view
  }()
  
  let newContainer: UIView = {
    let view = UIView()
    view.backgroundColor = YDColors.branding
    view.layer.masksToBounds = true
    view.layer.cornerRadius = 10
    return view
  }()

  let newLabel: UILabel = {
    let view = UILabel()
    view.textColor = .white
    view.textAlignment = .center
    view.font = UIFont.systemFont(ofSize: 14)
    view.text = "novo"
    return view
  }()
  
  // MARK: Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension HomeViewCell {
  
  // MARK: Actions
  func initView() { }
  
  func setupViews() {
    self.addSubview(card)
    card.addSubview(imageView)
    card.addSubview(titleLabel)
    card.addSubview(newContainer)
    newContainer.addSubview(newLabel)
    
    card.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      card.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
      card.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
      card.heightAnchor.constraint(equalToConstant: 138)
    ])
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalToConstant: 100),
      imageView.heightAnchor.constraint(equalToConstant: 100),
      imageView.centerYAnchor.constraint(equalTo: card.centerYAnchor),
      imageView.leadingAnchor
        .constraint(equalTo: card.leadingAnchor, constant: 26)
    ])
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
      titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
      titleLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor)
    ])
    
    newContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      newContainer.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
      newContainer.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
      newContainer.heightAnchor.constraint(equalToConstant: 22)
    ])
    
    newLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      newLabel.centerYAnchor.constraint(equalTo: newContainer.centerYAnchor),
      newLabel.leadingAnchor.constraint(equalTo: newContainer.leadingAnchor, constant: 12),
      newLabel.trailingAnchor.constraint(equalTo: newContainer.trailingAnchor, constant: -12)
    ])
    
  }
  
  func populateView(item: ItensOffinlineAccount) {
    imageView.image = item.icon
    titleLabel.text = item.title
    newContainer.isHidden = !item.new
  }
}
