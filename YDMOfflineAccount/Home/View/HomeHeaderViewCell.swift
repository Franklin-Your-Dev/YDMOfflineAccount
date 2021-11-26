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
  
  static let identifierCell = "HomeHeaderViewCell"
  
  var userProfileView = YDUserProfileView()
  
  func initView(user: YDCurrentCustomer) {
    userProfileView.config(username: user.fullName ?? "", userPhoto: nil)
    
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
