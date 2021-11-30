//
//  ItensOffinlineAccount.swift
//  YDMOfflineAccount
//
//  Created by magna on 30/11/21.
//

import UIKit

enum ItensOffilineAccountEnum {
  case store
  case clipboard
  case customerIdentifier
}

class ItensOffinlineAccount {
  let icon: UIImage
  let title: String
  let type: ItensOffilineAccountEnum
  let new : Bool
  
  init(icon: UIImage, title: String, type: ItensOffilineAccountEnum, new: Bool) {
    self.icon = icon
    self.title = title
    self.type = type
    self.new = new
  }
}
