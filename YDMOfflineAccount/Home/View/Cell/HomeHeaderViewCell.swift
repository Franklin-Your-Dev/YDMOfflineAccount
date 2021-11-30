//
//  HomeHeaderViewCell.swift
//  YDMOfflineAccount
//
//  Created by magna on 26/11/21.
//

import UIKit
import YDB2WComponents
import YDB2WModels

class HomeHeaderViewCell: UICollectionReusableView {
  
  // MARK: Views
  var userProfileView = YDUserProfileView()
  
  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: .zero)
    configUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Functions
  func populateView(user: YDCurrentCustomer) {
    userProfileView.config(username: user.fullName ?? "", userPhoto: nil)
  }
  
}

// MARK: UI
extension HomeHeaderViewCell {
  
  private func configUI() {
    userProfileView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(userProfileView)
    NSLayoutConstraint.activate([
      userProfileView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      userProfileView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      userProfileView.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
      userProfileView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24)
    ])
  }
  
}
